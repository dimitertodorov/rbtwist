require 'open-uri'
require 'nokogiri'
require 'openssl'
require 'pp'

# This is a standalone class used for parsing the HPSA WSDL Documents into a hash DB supported by Rbtwist.
#
module Rbtwist
  class Wsdl
    attr_accessor :document
    attr_accessor :target_namespace
    attr_accessor :namespaces
    attr_accessor :endpoint

    $RBTWIST_TYPE_HASH={}
    $NAMESPACE_HASH={}

    class << self
      attr_accessor :profiling
    end

    def self.parse(file_path)
      f=File.open(file_path)
      doc=Nokogiri::XML(f)
      f.close
      wsdl=Wsdl.new(doc)
    end

    def initialize(wsdl)
      @document=wsdl
      @target_namespace=@document.at_xpath("//xmlns:definitions")["targetNamespace"]
      @namespaces=@document.collect_namespaces
    end

    def schemas
      @document.xpath("//xmlns:types/xsd:schema")
    end


    def inspect
      "#<Wsdl #{@target_namespace}>"
    end

    def parse_schemas
      self.schemas.each do |schema|

        target_namespace=schema[:targetNamespace]
        types=schema.xpath('./xsd:complexType')
        types.each do |type|
          self.define_type(type,target_namespace,@namespaces)
        end
      end
    end

    def get_type_by_name(name,namespace)
      @document.at_xpath("//xmlns:types/xsd:schema[@targetNamespace='#{namespace}']/xsd:complexType[@name='#{name}']")
    end

    def object_namespaces(namespace)
      Rbtwist::Wsdl.xmlns_to_module(namespace)
    end

    def parse_namespaces
      @namespaces.each do |k,v|
        k='xmlns:'+abbreviate_namespace(v) if v=~ /opsware.com/
        $NAMESPACE_HASH[k]=v
      end
      $NAMESPACE_HASH
    end


    def get_namespaced_type(node)
      obj={}
      node_type_ns=node[:type].split(":").first
      if node[:type] =~ /ArrayOf/i
        non_ns_array_type=$'
        split_array=node[:type].split(":").last.split('_')
        node_type_ns = split_array.count==3 ? split_array[1] : node_type_ns
        array_type= split_array.count==3 ? split_array[2] : non_ns_array_type
        obj['is-array']=true
        obj['wsdl_type']=array_type
      else
        obj['is-array']=false
        obj['wsdl_type']=node[:type].split(":").last
      end
      node_namespace=namespaces["xmlns:#{node_type_ns}"]
      obj['namespace']=node_namespace
      abbreviated_namespace=self.abbreviate_namespace(obj['namespace'])

      obj['wsdl_ns_type']=abbreviated_namespace+":"+obj['wsdl_type']
      obj
    end

    def service_name
      service_node=self.document.at_xpath('//xmlns:service')
      service_name=service_node.attributes['name'].value
      service_name
    end

    def service_hash
      service_node=self.document.at_xpath('//xmlns:service')
      service_name=service_node.attributes['name'].value
      service_location=service_node.at_xpath("./xmlns:port/wsdlsoap:address/@location").value
      url=URI(service_location)
      service_path = url.path.gsub("/osapi",'')
      service_hash={
          'name' => service_name,
          'kind' => 'service',
          'wsdl_base' => 'ServiceObject',
          'methods' => self.get_methods,
          'props' => [],
          'namespace' => self.namespaces['xmlns:impl'],
          'method_prefix' => self.abbreviate_namespace(self.namespaces['xmlns:impl']),
          'service_path' => service_path
      }
      service_hash
    end


    def get_methods
      service_methods={}
      methods=self.document.xpath("//xmlns:portType/xmlns:operation")
      methods.each do |method|
        service_methods.merge! get_method_hash(method)
      end
      service_methods
    end

    def get_method_hash(method_node)
      method_name=method_node.attributes['name'].value
      method_hash={}
      method_input=method_node.at_xpath("./xmlns:input")
      if method_input
        method_hash['input-name']=method_input.attributes['name'].value
        method_hash['params']=get_message_parts method_hash['input-name']
      end
      method_output=method_node.at_xpath("./xmlns:output")
      if method_output
        method_hash['output-name']=method_output.attributes['name'].value
        method_hash['result']=get_message_parts method_hash['output-name']
      end
      {method_name => method_hash}

    end


    def get_message_parts message_name
      message_node=self.document.at_xpath("//xmlns:message[@name='#{message_name}']")
      if message_node
        part_array=[]
        parts=message_node.xpath("./xmlns:part")
        parts.each do |part|
          part_hash={}
          part_hash['name']=part.attributes['name'].value
          part_hash = part_hash.merge(self.get_namespaced_type(part))
          part_hash['is-optional']=true
          part_hash['version-id-ref']=nil
          part_array.push part_hash
        end
        part_array
      else
        []
      end
    end


    def define_type(node_element,target_namespace,namespaces)

      class_name=node_element['name']

      return if class_name =~ /ArrayOf.*/

      type_hash=Hash.new
      type_hash['name']=class_name
      type_hash['props']=[]
      type_hash['kind']='data'

      if node_element.xpath('xsd:complexContent/xsd:extension').count==1
        type_hash['wsdl_base']=node_element.at_xpath('xsd:complexContent/xsd:extension')[:base].split(':').last
        props=node_element.xpath(('xsd:complexContent/xsd:extension/xsd:sequence/xsd:element[@name]'))
      else
        type_hash['wsdl_base']='DataObject'
        props=node_element.xpath('xsd:sequence/xsd:element[@name]')
      end

      abstract = node_element.at_xpath('./@abstract') ? node_element.at_xpath('./@abstract').content : 'false'
      abbreviated_namespace=self.abbreviate_namespace(target_namespace)

      type_hash['namespace']=target_namespace
      type_hash['wsdl_ns_type']=abbreviated_namespace+":"+class_name
      type_hash['abstract']=abstract


      props.each do |prop|
        prop_hash={}
        prop_hash['name']=prop[:name]



        prop_hash['is-optional']=true
        prop_hash['version-id-ref']=nil
        prop_hash=prop_hash.merge(self.get_namespaced_type(prop))
        type_hash['props'].push prop_hash
      end
      $RBTWIST_TYPE_HASH[class_name] = type_hash

    end

    def abbreviate_namespace namespace
      if namespace=~ /opsware.com/
        namespace_uri=URI(namespace)
        abbreviated_namespace=namespace_uri.host.gsub('.opsware.com','')
      else
        abbreviated_namespace=@namespaces.invert[namespace].split(':')[1]
      end
      abbreviated_namespace
    end

    def self.xmlns_to_module(namespace)
      object_namespaces=[]
      uri=URI(namespace)
      host=uri.host
      parts=host.gsub('.opsware.com','').split('.')
      current_namespace="Rbtwist::Opsware"
      object_namespaces.push current_namespace
      parts.each do |p|
        current_namespace+="::#{p.capitalize}"
        object_namespaces.push current_namespace
      end
      object_namespaces
    end

    def self.parse_remote_wsdls host,port,services=[]
      wsdl_list_path=URI.parse("https://#{host}:#{port}/osapi/com/opsware/server/ServerService")
      output = Nokogiri.parse(open(wsdl_list_path.to_s, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
      wsdls = output.xpath("//a[@href]/@href").select {|e| e.value =~ /\/osapi\/com/ }
      wsdls.each do |wsdl|
        url=wsdl.value.gsub('http://','https://')
        uri=URI.parse(url)
        uri.host=host
        uri.port=port
        wsdl_service_name=uri.to_s.split('/').last.split('?')[0]
        if services.empty? or services.include? wsdl_service_name
          self.parse_wsdl(uri)
        else

        end
      end
      f=File.new("opsware_gen_#{Time.now.to_i}.db",'w')
      Marshal.dump($RBTWIST_TYPE_HASH,f)
      f.close
    end


      def self.parse_wsdl wsdl
        t1=Time.now
        if wsdl.class==File
          wxml=wsdl.read
          wsdl_service_name=File.basename(wsdl.path)
        elsif wsdl.class==URI::HTTP || wsdl.class==URI::HTTPS
          wxml=open(wsdl, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
          wsdl_service_name=wsdl.to_s.split('/').last.split('?')[0]
        else
          fail "WSDL Param must be a File or URI Object. Passed: #{wsdl}"
        end

        t2=Time.now
        doc=Wsdl.new(Nokogiri.parse(wxml))
        t3=Time.now
        doc.parse_schemas
        t4=Time.now
        $RBTWIST_TYPE_HASH[doc.service_name]=doc.service_hash
        t5=Time.now
        profile_hash={
            name: wsdl_service_name,
            download: t2-t1,
            nokogiri_parse: t3-t2,
            parse_schemas: t4-t3,
            parse_service: t5-t4
        }
        pp profile_hash
        doc
      end

    end

end