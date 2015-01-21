require 'spec_helper'

describe Rbtwist::Deserializer do
  describe 'deserialization' do
    before(:all) do
      conn = Opsware.new(:ns => 'common', :rev => '9.1')
      @deserializer = Rbtwist::Deserializer.new conn
    end

    def check str, expected, type
      got = @deserializer.deserialize Nokogiri(str).root, type
      expect(expected).to eq(got)
    end

    it 'should deserialize objects into XML' do
      check <<-EOS, Opsware.Filter(expression: 'ServerVO.hostName CONTAINS ITS', objectType: 'device'), 'Filter'
<root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="search:Filter">
  <expression xsi:type='xsd:string'>ServerVO.hostName CONTAINS ITS</expression>
  <objectType>device</objectType>
</root>
      EOS

      check <<-EOS, Opsware.ServerRef(id: 90002,idAsLong: 90002,name: "testservername",secureResourceTypeName: "device"), 'ServerRef'
<multiRef xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:ns2="http://server.opsware.com" id="id0" soapenc:root="0" soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xsi:type="ns2:ServerRef">
	<id xsi:type="xsd:long">90002</id>
	<idAsLong xsi:type="xsd:long">90002</idAsLong>
	<name xsi:type="xsd:string">testservername</name>
	<secureResourceTypeName xsi:type="xsd:string">device</secureResourceTypeName>
</multiRef>
      EOS
    end

    it 'should deserialize a Map object' do
      check <<-EOS, Opsware.Map([Opsware.MapItem(key: 1, value: "value"),Opsware.MapItem(key: 'string_key', value: 3.444)]), 'Map'
<root xsi:type="apachesoap:Map" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/">
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


    it 'should deserialize a complex object with arrays and nested DataObject' do
      vo=Opsware.ServerHardwareVO(
          assetTag: nil,
          beginDate: Time.parse("2015-01-19 07:01:40 UTC"),
          buses: [],
          chassisId: "SERIAL",
          cpus: [Opsware.CPUComponent(
                     beginDate: Time.parse("2014-08-30 19:18:55 UTC"),
          cacheSize: "4096",
          family: "X64",
          id: 235610002,
          model: "Intel(R) Xeon(R) CPU            5160  @ 3.00GHz",
          slot: "CPU0",
          speed: "1992",
          status: "ON-LINE",
          stepping: "11",
          vendor: "GENUINEINTEL"
      ),
          Opsware.CPUComponent(
              beginDate: Time.parse("2013-11-04 15:15:10 UTC"),
          cacheSize: "4096",
          family: "X64",
          id: 235620002,
          model: "Intel(R) Xeon(R) CPU            5160  @ 3.00GHz",
          slot: "CPU1",
          speed: "1992",
          status: nil,
          stepping: "11",
          vendor: "GENUINEINTEL"
      )],
          hwSignature: nil,
          interfaces: [Opsware.InterfaceComponent(
                           adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "0",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: nil,
          id: 111440002,
          ipAddress: nil,
          localHostName: "HOSTNAME10",
          netmask: nil,
          primaryInterface: false,
          slot: "[00000007] Microsoft ISATAP Adapter",
          speed: "0",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "0",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: "33:50:6F:45:30:30",
          id: 111470002,
          ipAddress: nil,
          localHostName: "HOSTNAME10",
          netmask: nil,
          primaryInterface: false,
          slot: "[00000003] WAN Miniport (PPPOE)",
          speed: "0",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "0",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: nil,
          id: 111450002,
          ipAddress: nil,
          localHostName: "HOSTNAME10",
          netmask: nil,
          primaryInterface: false,
          slot: "[00000013] Microsoft ISATAP Adapter",
          speed: "0",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "0",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: "50:50:54:50:30:30",
          id: 111500002,
          ipAddress: nil,
          localHostName: "HOSTNAME10",
          netmask: nil,
          primaryInterface: false,
          slot: "[00000002] WAN Miniport (PPTP)",
          speed: "0",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "100",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: "00:15:17:72:66:B8",
          id: 111460002,
          ipAddress: nil,
          localHostName: "HOSTNAME10",
          netmask: nil,
          primaryInterface: false,
          slot: "User-Facing 1",
          speed: "100",
          type: "ETHERNET",
          useDHCP: true,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "1000",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: "00:1A:64:78:B2:36",
          id: 111530002,
          ipAddress: "10.88.195.76",
          localHostName: "HOSTNAME10",
          netmask: "255.255.255.0",
          primaryInterface: false,
          slot: "Backup",
          speed: "1000",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "100",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: "00:1A:64:78:B2:34",
          id: 111490002,
          ipAddress: nil,
          localHostName: "HOSTNAME10",
          netmask: nil,
          primaryInterface: false,
          slot: "User-Facing 2",
          speed: "100",
          type: "ETHERNET",
          useDHCP: true,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "100",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: "00:15:17:72:66:B8",
          id: 111520002,
          ipAddress: "10.88.214.123",
          localHostName: "HOSTNAME10",
          netmask: "255.255.255.0",
          primaryInterface: false,
          slot: "Team user int",
          speed: "100",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "100",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: "00:15:17:72:66:B9",
          id: 111480002,
          ipAddress: "10.88.214.124",
          localHostName: "HOSTNAME10",
          netmask: "255.255.255.0",
          primaryInterface: false,
          slot: "Mgmt",
          speed: "100",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "0",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: "20:41:53:59:4E:FF",
          id: 111510002,
          ipAddress: nil,
          localHostName: "HOSTNAME10",
          netmask: nil,
          primaryInterface: false,
          slot: "[00000011] RAS Async Adapter",
          speed: "0",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      ),
          Opsware.InterfaceComponent(
              adminEnabled: false,
          beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          collisions: nil,
          configuredDuplex: nil,
          configuredSpeed: "0",
          connectedTo: nil,
          descriptor: nil,
          duplex: nil,
          enabled: true,
          hardwareAddress: nil,
          id: 111430002,
          ipAddress: nil,
          localHostName: "HOSTNAME10",
          netmask: nil,
          primaryInterface: false,
          slot: "[00000014] Microsoft ISATAP Adapter",
          speed: "0",
          type: "ETHERNET",
          useDHCP: false,
          vendor: nil
      )],
          manufacturer: "IBM",
          memories: [Opsware.MemoryComponent(
                         beginDate: Time.parse("2013-04-22 15:15:24 UTC"),
          id: 35290002,
          quantity: "4193388",
          type: "RAM",
          vendor: nil
      ),
          Opsware.MemoryComponent(
              beginDate: Time.parse("2014-09-20 13:34:07 UTC"),
          id: 35300002,
          quantity: "4127688",
          type: "SWAP",
          vendor: nil
      )],
          model: "MODELTEST",
          ref: Opsware.ServerRef(
          id: 17800002,
          idAsLong: 17800002,
          name: "HOSTNAME10",
          secureResourceTypeName: "device"
      ),
          serialNumber: "SERIAL",
          storages: [Opsware.StorageComponent(
                         beginDate: Time.parse("2013-04-22 15:15:23 UTC"),
          capacity: "0",
          drive: "F:",
          id: 86490002,
          media: "CDROM",
          model: "HL-DT-ST RW/DVD GCC-T10N ATA Device",
          type: "Storage",
          vendor: nil
      ),
          Opsware.StorageComponent(
              beginDate: Time.parse("2013-04-22 15:15:23 UTC"),
          capacity: "0",
          drive: "E:",
          id: 86500002,
          media: "CDROM",
          model: "BOZIN DQ3OPEJOXUR0 SCSI CdRom Device",
          type: "Storage",
          vendor: nil
      ),
          Opsware.StorageComponent(
              beginDate: Time.parse("2013-04-22 15:15:23 UTC"),
          capacity: "139894",
          drive: "PHYSICALDRIVE0",
          id: 86480002,
          media: "SCSI DISK",
          model: "Adaptec Array SCSI Disk Device",
          type: "SCSI",
          vendor: nil
      )],
          uuid: "0b517d45-473a-33c4-9aa9-8fc7707d1ccf"
      )
      xml=File.new('spec/xml/ServerHardwareVO.xml').read
      check xml, vo, 'ServerHardwareVO'
    end
  end
end