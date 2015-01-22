# Dimiter Todorov - 2014
require 'time'

module Rbtwist

class Deserializer
  NS_XSI = 'http://www.w3.org/2001/XMLSchema-instance'

  DEMANGLED_ARRAY_TYPES = {
    'AnyType' => 'xsd:anyType',
    'DateTime' => 'xsd:dateTime',
  }
  %w(Boolean String Byte Short Int Long Float Double).each do |x|
    DEMANGLED_ARRAY_TYPES[x] = "xsd:#{x.downcase}"
  end

  BUILTIN_TYPE_ACTIONS = {
    'xsd:string' => :string,
    'xsd:boolean' => :boolean,
    'xsd:byte' => :int,
    'xsd:short' => :int,
    'xsd:int' => :int,
    'xsd:long' => :int,
    'xsd:float' => :float,
    'xsd:double' => :double,
    'xsd:dateTime' => :date,
    'PropertyPath' => :string,
    'MethodName' => :string,
    'TypeName' => :string,
    'xsd:base64Binary' => :binary,
    'KeyValue' => :keyvalue,
  }

  BUILTIN_TYPE_ACTIONS.dup.each do |k,v|
    if k =~ /^xsd:/
      BUILTIN_TYPE_ACTIONS[$'] = v
    end
  end

  def initialize conn
    @conn = conn
    @loader = conn.class.loader
  end

  def deserialize node, type=nil
    t1=Time.now
    type_attr = node['type']
    if node.attributes['type'] and not type_attr
      type_attr = node.attributes['type'].value
    end

    if node.attributes['nil']
      return
    end

    type = type_attr if type_attr

    #Force string type for non-typed arrays.
    if !type && node.name=='item'
      type='xsd:string'
    end
    if action = BUILTIN_TYPE_ACTIONS[type]
      case action
      when :string
        node.content
      when :boolean
        node.content == '1' || node.content == 'true'
      when :int
        node.content.to_i
      when :float
        node.content.to_f
      when :date
        leaf_date node
      when :binary
        leaf_binary node
      when :keyvalue
        leaf_keyvalue node
      else fail
      end
    else
      if type =~ /:/
        type = type.split(":", 2)[1]
      end

      if type =~ /^ArrayOf/
        type = DEMANGLED_ARRAY_TYPES[$'] || $'
        return node.children.select(&:element?).map { |c| deserialize c, type }
      end

      if type =~ /:/
        type = type.split(":", 2)[1]
      end

      if type =~ /^Array/
        type=node.attributes['arrayType'].value.gsub(/\[.*\]/,'').split(':').last
        return node.children.select(&:element?).map { |c| deserialize c, type }
      end
      #Assuming that a Map can only contain a mapItem.
      if type =~ /^Map/
        return Rbtwist::Opsware::Map.new(node.children.select(&:element?).map { |c| deserialize c, 'mapItem' })
      end

      klass = @loader.get(type) or fail "no such type '#{type}'"

      case klass.kind
      when :data
        traverse_data node, klass
      when :enum
        node.content
      when :managed
        leaf_managed node, klass
      else fail
      end

    end

  end

  def traverse_data document, klass, id=nil
    t1=Time.now
    node = document


    obj = klass.new nil
    props = obj.props

    children = node.children.select(&:element?)
    n = children.size

    i = 0
    klass.full_props_desc.each do |desc|
      t3=Time.now
      name = desc['name']
      child_type = desc['wsdl_type']

      prop_node=nil

      node.children.select(&:element?).each do |e|
        prop_node=e if e.name.split(':').last==name
      end

      if prop_node.attributes['type']
        props[name.to_sym] = deserialize(prop_node,prop_node.attributes['type'])
      end

      if desc['is-array']
        i=0
        prop_node_children=prop_node.children.select(&:element?)
        arr = []

        while ((child = prop_node_children[i]))
          child = prop_node_children[i]
          arr << deserialize(child, child_type)
          i += 1
        end
        props[name.to_sym] = arr.flatten.compact
      elsif !desc['is-array'] && !prop_node.attributes['type']
        props[name.to_sym] = prop_node.content
      end
      t4=Time.now
    end
    t2=Time.now

    # Reset dirtyAttributes. Keeps the object pristine.
    obj.dirtyAttributes=[] if obj.class.ancestors.include? Rbtwist::Opsware::ModifiableVO

    obj
  end

  def leaf_managed node, klass
    type_attr = node['type']
    klass = @loader.get(type_attr) if type_attr
    klass.new(@conn, node.content)
  end

  def leaf_date node
    Time.parse node.content
  end

  def leaf_binary node
    node.content.unpack('m')[0]
  end

  # XXX does the value need to be deserialized?
  def leaf_keyvalue node
    h = {}
    node.children.each do |child|
      next unless child.element?
      h[child.name] = child.content
    end
    [h['key'], h['value']]
  end 
end

end
