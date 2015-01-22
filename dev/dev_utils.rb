#Helpful Methods for Testing.
require './lib/rbtwist'
Opsware=Rbtwist::Opsware
cli=Rbtwist.get_connection

def server_service
  client=Rbtwist.get_connection
  Rbtwist::Opsware::ServerService.new(client)
end

def search_service
  client=Rbtwist.get_connection
  Rbtwist::Opsware::SearchService.new(client)
end

def sample_filter
  f=Rbtwist::Opsware::Filter.new
  f.expression='ServerVO.hostName CONTAINS THISNAME'
  f.objectType='device'
  f
end

def sample_search_server
  server_service.findServerRefs({filter: sample_filter})
end


def get_server_vos_by_filter filter_expr
  filter=Rbtwist::Opsware::Filter.new
  filter.expression=filter_expr
  refs=server_service.findServerRefs({filter: filter})
  vos=server_service.getServerVOs({selves: refs})
end

def get_server_vos_by_hostname hostname
  filter=Rbtwist::Opsware::Filter.new
  filter.expression="ServerVO.hostName CONTAINS #{hostname}"
  refs=server_service.findServerRefs({filter: filter})
  vos=server_service.getServerVOs({selves: refs})
end

def simple_serialize obj, type, array=false
  xml = Builder::XmlMarkup.new :indent => 2
  Rbtwist.get_connection.obj2xml(xml, 'root', type, array, obj)
end


def load_test
  vos=[]
  Rbtwist.get_connection(true)
  Rbtwist.get_connection.profiling=true
  ss=Rbtwist::Opsware.ServerService(Rbtwist.get_connection)
  5.times do
    filter=Rbtwist::Opsware::Filter.new
    filter.expression='device_customer_name EQUAL_TO AD'
    refs=ss.findServerRefs({filter: filter})
    vos = server_service.getServerVOs({selves: refs})
    puts refs.count
  end
  pp Rbtwist.get_connection.profile_summary
  return vos
end


def run_script
  filter=Opsware.Filter(expression: '(ServerVO.hostName CONTAINS SOMENAME)&(ServerVO.osVersion CONTAINS Win)')
  servers=server_service.findServerRefs(filter: filter)
  pp servers
  source='hostname'
  source_type='BAT'
  args=Opsware::ServerScriptJobArgs.new(targets: servers)
  ss=Opsware.ServerScriptService(Rbtwist.get_connection)
  ss.startAdhocServerScript(source: source, sourceCodeType: source_type, args: args, userTag: 'Test from RBTWIST')
end

def job_service
  Opsware::JobService(Rbtwist.get_connection)
end

def get_job_progress job_id
  js=job_service
  js.getProgress(self: Opsware.JobRef(id: job_id))
end

def get_job_info job_id
  js=job_service
  job_vo=js.getJobInfoVO(self: Opsware.JobRef(id: job_id))
  job_vo
end

def script_job_output job_id
  ssjs=Opsware.ServerScriptService(Rbtwist.get_connection)
  job_vo= get_job_info job_id
  servers=job_vo.serverInfo.map {|si| si.server}
  servers.each do |server|
    ssjo=ssjs.getServerScriptJobOutput(job: job_vo.ref, server: server)
    puts ssjo.tailStdout
  end
end

def virtual_server_service
  Opsware.V12nVirtualServerService(Rbtwist.connection)
end





def load!
  load './dev/dev_utils.rb'
end