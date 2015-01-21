require 'spec_helper'


describe Opsware::ModifiableVO do
  describe '#dirtyAttributes' do
    it 'should be initialized with no dirty attributes' do
      expect(@vo.dirtyAttributes).to eq([])
    end

    it 'should flag a basic attribute update' do
      @vo.description='CHANGE_DESC'
      expect(@vo.dirtyAttributes).to eq(['description'])
    end


    it 'should flag a complex attribute update' do
      customer=Opsware.CustomerRef(id: 10023, idAsLong: 10023, name:'CUSTOMER1', secureResourceTypeName: 'customer')
      @vo.customer=customer
      expect(@vo.dirtyAttributes).to eq(['customer'])
    end








    before(:each) do
      @vo=complex_object=Opsware.ServerVO(
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
    end
  end
end