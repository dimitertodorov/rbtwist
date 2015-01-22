require 'integration/spec_helper'

describe Opsware::ServerService do
  describe 'read operations' do
    it 'should find a list of servers based on filter' do
      refs=@server_service.findServerRefs(filter: @filter)
      expect(refs.count).to eq(1)
      expect(refs.first.class).to eq(Opsware::ServerRef)
    end

    it 'should get a VO from a ServerRef' do
      refs=@server_service.findServerRefs(filter: @filter)
      vos=@server_service.getServerVOs(selves: refs)
      expect(vos.count).to eq(1)
      expect(vos.first.class).to eq(Opsware::ServerVO)
    end

  describe 'write operations' do
    it 'should reassign to a new customer and back' do
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

    it 'should update description' do
      refs=@server_service.findServerRefs(filter: @filter)
      vos=@server_service.getServerVOs(selves: refs)
      time_now=Time.now.to_s
      vos.first.description=time_now
      vo=@server_service.update(self: vos.first.ref, vo: vos.first, force: false, refetch: true)
      expect(vo.description).to eq(time_now)
    end


  end


  end

  before(:all) do
    @server_service=Opsware.ServerService(Rbtwist.get_connection(true))
    #Rbtwist.get_connection.debug=true
    @filter=Opsware.Filter(TEST_CONFIG[:server_service][:server_filter])


  end
end