require 'integration/spec_helper'

describe Opsware::ServerService do
  describe 'read operations' do
    it "should call findServerRefs with Filter(#{TEST_CONFIG[:server_service][:server_filter]})"  do
      refs=@server_service.findServerRefs(filter: @filter)
      expect(refs.count).to eq(1)
      expect(refs.first.class).to eq(Opsware::ServerRef)
    end

    it 'should call getServerVO' do
      refs=@server_service.findServerRefs(filter: @filter)
      vos=@server_service.getServerVOs(selves: refs)
      expect(vos.count).to eq(1)
      expect(vos.first.class).to eq(Opsware::ServerVO)
    end
  end
  describe 'write operations' do
    before { skip "Write tests disabled in spec. Remove or comment out skip line to test."}

    it "should call setCustomer with CustomerRef and change back to original" do
      refs=@server_service.findServerRefs(filter: @filter)
      vos=@server_service.getServerVOs(selves: refs)
      original_customer_ref=vos.first.customer
      new_customer_ref=Opsware.CustomerRef(TEST_CONFIG[:server_service][:customer_change][:customer])
      @server_service.setCustomer(self: refs.first, customer: new_customer_ref)
      vos=@server_service.getServerVOs(selves: refs)
      expect(vos.first.customer.id).to eq(new_customer_ref.id)
      @server_service.setCustomer(self: refs.first, customer: original_customer_ref)
      vos=@server_service.getServerVOs(selves: refs)
      expect(vos.first.customer.id).to eq(original_customer_ref.id)
    end

    it "should update description and verify" do
      refs=@server_service.findServerRefs(filter: @filter)
      vos=@server_service.getServerVOs(selves: refs)
      vos.first.description=@current_time
      vo=@server_service.update(self: vos.first.ref, vo: vos.first, force: false, refetch: true)
      expect(vo.description).to eq(@current_time)
    end


  end



  before(:all) do
    @server_service=Opsware.ServerService(Rbtwist.get_connection(true))
    #Rbtwist.get_connection.debug=true
    @filter=Opsware.Filter(TEST_CONFIG[:server_service][:server_filter])
    @current_time=Time.now.to_s
  end
end