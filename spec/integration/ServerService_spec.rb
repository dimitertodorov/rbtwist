require 'integration/spec_helper'

describe Opsware::ServerService do
  describe 'read operations' do
    it 'should find a list of servers based on filter' do
      filter=Opsware.Filter(TEST_CONFIG[:server_service][:server_filter])
      refs=@server_service.findServerRefs(filter: filter)
      expect(refs.count).to eq(1)
      expect(refs.first.class).to eq(Opsware::ServerRef)
    end

    it 'should get a VO from a ServerRef' do
      filter=Opsware.Filter(TEST_CONFIG[:server_service][:server_filter])
      refs=@server_service.findServerRefs(filter: filter)
      vos=@server_service.getServerVOs(selves: refs)
      expect(vos.count).to eq(1)
      expect(vos.first.class).to eq(Opsware::ServerVO)
    end

    it 'should update description to current DateTime'

  end

  before(:all) do
    @server_service=Opsware.ServerService(Rbtwist.get_connection(true))

  end
end