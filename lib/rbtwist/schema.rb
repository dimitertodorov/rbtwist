module Rbtwist
  class Schema
    attr_accessor :target_namespace
    attr_accessor :types
    attr_accessor :document

    def initialize(xml,namespaces,document)
      @target_namespace=xml[:targetNamespace]
      @namespaces=namespaces
      @types=xml.xpath('./xsd:complexType')
      @document=document
    end

    def define_types
      classes=[]
      @types.each do |type|
        @document.define_class(type,@target_namespace,@namespaces)
      end

    end


  end
end