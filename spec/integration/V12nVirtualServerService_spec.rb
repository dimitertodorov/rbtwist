require 'integration/spec_helper'



describe Rbtwist::Opsware::V12nVirtualServerService do
  describe 'read operations' do
    it "should call findV12nVirtualServerRefs with Filter(#{TEST_CONFIG[:v12n_service][:server_filter]})"  do
      refs=@service.findV12nVirtualServerRefs(filter: @filter)
      expect(refs.count).to eq(1)
      expect(refs.first.class).to eq(Opsware::V12nVirtualServerRef)
    end

    it 'should call getV12nVirtualServerVO' do
      refs=@service.findV12nVirtualServerRefs(filter: @filter)
      vos=@service.getV12nVirtualServerVOs(selves: refs)
      expect(vos.first.vendorIdentities.to_hash['Vmware_Moid']).to be
      expect(vos.count).to eq(1)
      expect(vos.first.class).to eq(Opsware::V12nVirtualServerVO)
    end

    describe 'write operations' do
      before { skip }




    end


  end

  before(:all) do
    skip "V12nVirtualServerService only supported on SA 10+" unless Rbtwist.version =~ /^10/
    @service=Opsware.V12nVirtualServerService(Rbtwist.get_connection(true))
    @filter=Opsware.Filter(TEST_CONFIG[:v12n_service][:server_filter])
    @current_time=Time.now.to_s
  end
end