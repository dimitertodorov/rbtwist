require 'pathname'
require 'logger'
require 'yaml'
require 'erb'




module Rbtwist
  unless const_defined? :START_TIME
    START_TIME = Time.now
  end

  class << self
    attr_accessor :namespaces
    attr_accessor :objects
    attr_accessor :connection
    attr_accessor :logger
  end

  def self.env
    if defined? @@env and @@env
      @@env
    elsif ENV['RBTWIST_ENV']
      ENV['RBTWIST_ENV']
    else
      if defined? Rails
        Rails.env
      else
        ENV['RAILS_ENV'] || 'development'
      end
    end
  end

  def self.config_filename=(location)
    @config_filename = location
  end

  def self.config_filename
    @config_filename ||= "#{ENV['RAILS_ROOT'] || Dir.pwd}/config/rbtwist.yml"
  end

  def self.config_data
    YAML.load(ERB.new(File.new(config_filename).read).result)
  end

  def self.config
    config_data[Rbtwist.env]
  end


  def self.server
    config['server']
  end

  def self.user
    config['user']
  end

  def self.password
    config['password']
  end

  def self.port
    config['port']
  end

  def self.version
    begin
      ENV['RBTWIST_SA_VERSION'] ? ENV['RBTWIST_SA_VERSION'] : config['version'].to_s
    rescue Errno::ENOENT => e
      logger.fatal "Target SA Version must be specified either in ENV['RBTWIST_SA_VERSION'] or config/rbtwist.yml"
      exit 1
    end
  end

  def self.lib_path
    Pathname.new(__FILE__).parent
  end

  def self.wsdl_path
    @wsdl_path ||= "#{ENV['RAILS_ROOT'] || Dir.pwd}/config/wsdl/"
  end

  def self.wsdls
    Dir[Rbtwist.wsdl_path+"*.wsdl"]
  end

  def self.initialize!
    @namespaces=Hash.new
    @objects=Hash.new
  end

  def self.client(endpoint,namespace)
    client=Savon.client(ssl_verify_mode: :none, endpoint: endpoint, namespace: namespace, basic_auth: [self.user, self.password])
    return client
  end

  def self.reload_time
    @reload_time || START_TIME
  end

  def self.add_namespace(namespace)
    if namespace[1]=~/opsware.com/
      abbreviation=URI(namespace[1]).host.gsub(".opsware.com",'')
    else
      abbreviation=namespace[0]
    end
    puts abbreviation
    @namespaces[abbreviation]=namespace[1]
  end



  def self.get_connection(reconnect=false)
    @connection=nil if reconnect
    opts={
        host: self.server,
        rev: self.version,
        user: self.user,
        password: self.password,
        port: self.port,
        ssl: true,
        path: '/osapi'
    }
    @connection ||= Rbtwist::Opsware.new(opts)
  end


  def self.reload!
    lib_path.find do |path|
      if path.extname == '.rb' and path.mtime > reload_time
        puts path.to_s
        load path.to_s
      end
    end
    @reload_time = Time.now
  end

  @logger=Logger.new(STDOUT)
  @logger.level = ENV['RBTWIST_DEBUG'] ? Logger::DEBUG : Logger::WARN
  @logger.debug "Loading Rbtwist with target SA Version: #{self.version}"

end

class String
  def capitalize_first_letter
    self[0].capitalize+self[1,self.size]
  end

end

require_relative 'rbtwist/connection'

require_relative 'rbtwist/opsware'

