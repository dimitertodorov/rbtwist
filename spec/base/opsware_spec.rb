require 'base/spec_helper'


describe Opsware do
  before(:all) do
    @conn = Opsware.new(:ns => 'common', :rev => '9.1')
  end

  def check str, obj, type, array=false
    xml = Builder::XmlMarkup.new :indent => 2
    @conn.obj2xml(xml, 'root', type, array, obj)
    expect(str).to eq(xml.target!)

    #str.should eql xml.target!
    #
    # begin
    #   assert_equal str, xml.target!
    # rescue Minitest::Assertion
    #   puts "expected:"
    #   puts str
    #   puts
    #   puts "got:"
    #   puts xml.target!
    #   puts
    #   raise
    # end
  end

  describe 'serialization' do
    it 'serializes a data object' do
      check <<-EOS, Opsware.Filter({expression: 'ServerVO.hostName CONTAINS CTS', objectType: 'device'}), "Filter"
<root xsi:type="search:Filter">
  <expression>ServerVO.hostName CONTAINS CTS</expression>
  <objectType>device</objectType>
</root>
      EOS
    end

    it 'serializes a Map object' do
      map=Opsware.Map([Opsware.MapItem(key: 1, value: "value"),Opsware.MapItem(key: 'string_key', value: 3.444)])
      check <<-EOS, map, "Map"
<root xsi:type="apachesoap:Map">
  <item xsi:type="apachesoap:mapItem">
    <key xsi:type="xsd:long">1</key>
    <value xsi:type="xsd:string">value</value>
  </item>
  <item xsi:type="apachesoap:mapItem">
    <key xsi:type="xsd:string">string_key</key>
    <value xsi:type="xsd:float">3.444</value>
  </item>
</root>
      EOS
    end

    it 'serializes a complex (VO) object with nested props' do
      complex_object=Opsware.ServerVO(
          :ref => Opsware.ServerRef(
              id: 600001,
              idAsLong: 600001,
              name: "SOMETESTHOSTNAME",
              secureResourceTypeName: "device"
          ),
          :createdBy=>"sharpa_local",
          :createdDate=>Time.parse('2014-08-11 14:33:05 UTC'),
          :dirtyAttributes=>[],
          :logChange=>true,
          :modifiedBy=>nil,
          :modifiedDate=>nil,
          :description=>nil,
          :hostName=>"SOMETESTHOSTNAME.ad.com",
          :manufacturer=>"VMWARE, INC.",
          :model=>"VMWARE VIRTUAL PLATFORM",
          :osVersion=>
          "Microsoft Windows Server 2008 Enterprise  x64 Service Pack 2 Build 6002 (12-19-2013)",
          :primaryIP=>Time.parse('2014-08-11 14:33:05 UTC'),
          :serialNumber=>"VMWARE-42 39 C9 5F C1 39 0B AF-1F E8 8D 85 91 A9 11 B8",
          :agentVersion=>"55.0.51388.0",
          :codeset=>"CP1252",
          :customer=>
          Opsware.CustomerRef(
              id: 9,
              idAsLong: 9,
              name: "Not Assigned",
              secureResourceTypeName: "customer"
          ),
          :defaultGw=>"10.2.3.1",
          :discoveredDate=>Time.parse('2014-08-11 14:33:05 UTC'),
          :facility=>
          Opsware.FacilityRef(
              id: 1,
              idAsLong: 1,
              name: "facility",
              secureResourceTypeName: "facility"
          ),
          :firstDetectDate=>nil,
          :hypervisor=>false,
          :lastScanDate=>nil,
          :locale=>"1033",
          :lockInfo=>Opsware.LockInfo( comment: nil, date: nil, locked: false, user: nil ),
          :loopbackIP=>nil,
          :managementIP=>"10.2.3.4",
          :mid=>"600001",
          :name=>"SOMETESTHOSTNAME",
          :netBIOSName=>nil,
          :opswLifecycle=>"MANAGED",
          :origin=>"ASSIMILATED",
          :osFlavor=>"Windows Server 2008 Enterprise x64",
          :osSPVersion=>"SP2",
          :peerIP=>"10.2.3.4",
          :platform=>
            Opsware.PlatformRef( id: 170076, idAsLong: 170076, name: "Windows Server 2008 x64" ),
          :previousSWRegDate=>Time.parse('2014-08-11 14:33:05 UTC'),
          :realm=>
          Opsware.RealmRef(
              id: 30001,
              idAsLong: 30001,
              name: "facility-agents",
              secureResourceTypeName: "realm"
          ),
          :rebootRequired=>false,
          :reporting=>true,
          :stage=>"UNKNOWN",
          :state=>"OK",
          :use=>"UNKNOWN",
          :virtualizationType=>1)
      check <<-EOS, complex_object, "ServerVO"
<root xsi:type="server:ServerVO">
  <ref xsi:type="server:ServerRef">
    <id>600001</id>
    <idAsLong>600001</idAsLong>
    <name>SOMETESTHOSTNAME</name>
    <secureResourceTypeName>device</secureResourceTypeName>
  </ref>
  <createdBy>sharpa_local</createdBy>
  <createdDate>2014-08-11T14:33:05Z</createdDate>
  <dirtyAttributes xsi:type="soapenc:Array" soapenc:ArrayType="xsd:string[]">
  </dirtyAttributes>
  <logChange>true</logChange>
  <hostName>SOMETESTHOSTNAME.ad.com</hostName>
  <manufacturer>VMWARE, INC.</manufacturer>
  <model>VMWARE VIRTUAL PLATFORM</model>
  <osVersion>Microsoft Windows Server 2008 Enterprise  x64 Service Pack 2 Build 6002 (12-19-2013)</osVersion>
  <primaryIP>2014-08-11T14:33:05Z</primaryIP>
  <serialNumber>VMWARE-42 39 C9 5F C1 39 0B AF-1F E8 8D 85 91 A9 11 B8</serialNumber>
  <agentVersion>55.0.51388.0</agentVersion>
  <codeset>CP1252</codeset>
  <customer xsi:type="locality:CustomerRef">
    <id>9</id>
    <idAsLong>9</idAsLong>
    <name>Not Assigned</name>
    <secureResourceTypeName>customer</secureResourceTypeName>
  </customer>
  <defaultGw>10.2.3.1</defaultGw>
  <discoveredDate>2014-08-11T14:33:05Z</discoveredDate>
  <facility xsi:type="locality:FacilityRef">
    <id>1</id>
    <idAsLong>1</idAsLong>
    <name>facility</name>
    <secureResourceTypeName>facility</secureResourceTypeName>
  </facility>
  <hypervisor>false</hypervisor>
  <locale>1033</locale>
  <lockInfo xsi:type="server:LockInfo">
    <locked>false</locked>
  </lockInfo>
  <managementIP>10.2.3.4</managementIP>
  <mid>600001</mid>
  <name>SOMETESTHOSTNAME</name>
  <opswLifecycle>MANAGED</opswLifecycle>
  <origin>ASSIMILATED</origin>
  <osFlavor>Windows Server 2008 Enterprise x64</osFlavor>
  <osSPVersion>SP2</osSPVersion>
  <peerIP>10.2.3.4</peerIP>
  <platform xsi:type="device:PlatformRef">
    <id>170076</id>
    <idAsLong>170076</idAsLong>
    <name>Windows Server 2008 x64</name>
  </platform>
  <previousSWRegDate>2014-08-11T14:33:05Z</previousSWRegDate>
  <realm xsi:type="locality:RealmRef">
    <id>30001</id>
    <idAsLong>30001</idAsLong>
    <name>facility-agents</name>
    <secureResourceTypeName>realm</secureResourceTypeName>
  </realm>
  <rebootRequired>false</rebootRequired>
  <reporting>true</reporting>
  <stage>UNKNOWN</stage>
  <state>OK</state>
  <use>UNKNOWN</use>
  <virtualizationType>1</virtualizationType>
</root>
      EOS
    end

    it 'should serialize array of xsd:string[]' do
      obj = ["foo", "bar", "baz"]
      check <<-EOS, obj, "xsd:string", true
<root xsi:type="soapenc:Array" soapenc:ArrayType="xsd:string[]">
  <xsd:string xsi:type="xsd:string">foo</xsd:string>
  <xsd:string xsi:type="xsd:string">bar</xsd:string>
  <xsd:string xsi:type="xsd:string">baz</xsd:string>
</root>
      EOS
    end

    it 'should serialize array of xsd:int[]' do
      obj = [1,2,3]
      check <<-EOS, obj, "xsd:int", true
<root xsi:type="soapenc:Array" soapenc:ArrayType="xsd:int[]">
  <xsd:int>1</xsd:int>
  <xsd:int>2</xsd:int>
  <xsd:int>3</xsd:int>
</root>
      EOS
    end

    it 'should serialize array of xsd:boolean[]' do
      obj = [true,false,true]
      check <<-EOS, obj, "xsd:boolean", true
<root xsi:type="soapenc:Array" soapenc:ArrayType="xsd:boolean[]">
  <xsd:boolean>true</xsd:boolean>
  <xsd:boolean>false</xsd:boolean>
  <xsd:boolean>true</xsd:boolean>
</root>
      EOS
    end

    it 'should serialize xsd:float' do
      obj = [0.0,1.5,3.14]
      check <<-EOS, obj, "xsd:float", true
<root xsi:type="soapenc:Array" soapenc:ArrayType="xsd:float[]">
  <xsd:float>0.0</xsd:float>
  <xsd:float>1.5</xsd:float>
  <xsd:float>3.14</xsd:float>
</root>
      EOS
    end

    it 'should serialize xsd:base64Binary' do
      obj = "\x00foo\x01bar\x02baz"
      check <<-EOS, obj, 'xsd:base64Binary'
<root>AGZvbwFiYXICYmF6</root>
      EOS
    end


    it 'should serialize objects for xsd:AnyType target with xsi:type attribute' do
      obj = 1
      check <<-EOS, obj, 'xsd:anyType', false
<root xsi:type="xsd:long">1</root>
      EOS

      obj = Opsware::ServerRef(:id => 123440001, :name => 'testserver')
      check <<-EOS, obj, 'xsd:anyType', false
<root xsi:type="server:ServerRef">
  <id>123440001</id>
  <name>testserver</name>
</root>
      EOS
    end
  end

  describe 'should raise proper Opsware Type exceptions' do
    before(:all) do
      @not_found_exception=File.new(File.join(File.dirname(__FILE__), 'xml/NotFoundException.xml')).read
    end

    it 'should parse and raise a not found exception' do
      nk_exception_response=Nokogiri.parse(@not_found_exception)
      expect {
        parsed_response=@conn.parse_new(nk_exception_response,{'is-array'=>false})
      }.to raise_error { |error|
        expect(error.fault.class).to eq(Opsware::NotFoundException)
        expect(error.fault.objects[0].id).to eq(6000123)
      }
    end



  end

end