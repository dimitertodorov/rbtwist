module Rbtwist
  class Response
    attr_accessor :request
    attr_accessor :response
    attr_accessor :xml

    def initialize(response)
      @response=response
      @xml=Nokogiri.parse(response.xml)
    end


    def operation_return
      @xml.xpath("//*[contains(name(),'Return')]")
    end

    def get_item_by_id(id)
      id.gsub!('#','')
      @xml.at_xpath("//*[@id='#{id}']")
    end

    def get_item_class(item)
      type=item.at_xpath('./@xsi:type')
      class_name=type.content.split(':')[1].capitalize_first_letter
      ns=type.content.split(':')[0]
      namespace=item.namespaces["xmlns:#{ns}"]
      class_pkg=Rbtwist::Wsdl.xmlns_to_module(namespace)
      class_path="#{class_pkg.last}::#{class_name}"
      begin
        eval class_path
      rescue NameError => e
        puts e
      end

    end
  end
end