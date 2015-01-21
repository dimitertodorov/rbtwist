# Dimiter Todorov - 2014
require 'rubygems'
require 'builder'
require 'nokogiri'
require 'net/http'
require 'pp'

class Rbtwist::TrivialSoap
  attr_accessor :debug, :cookie
  attr_reader :http

  def namespaces
    {'xmlns'=>'http://www.w3.org/2001/XMLSchema',
     'xmlns:apachesoap'=>'http://xml.apache.org/xml-soap',
     'xmlns:v12n'=>'http://v12n.opsware.com',
     'xmlns:soapenc'=>'http://schemas.xmlsoap.org/soap/encoding/',
     'xmlns:common'=>'http://common.opsware.com',
     'xmlns:osprov'=>'http://osprov.opsware.com',
     'xmlns:search'=>'http://search.opsware.com',
     'xmlns:compatibility.v12n'=>'http://compatibility.v12n.opsware.com',
     'xmlns:custattr'=>'http://custattr.opsware.com',
     'xmlns:pkg'=>'http://pkg.opsware.com',
     'xmlns:microsoft.v12n'=>'http://microsoft.v12n.opsware.com',
     'xmlns:cloud.v12n'=>'http://cloud.v12n.opsware.com',
     'xmlns:sco.compliance'=>'http://sco.compliance.opsware.com',
     'xmlns:apx'=>'http://apx.opsware.com',
     'xmlns:job'=>'http://job.opsware.com',
     'xmlns:storage'=>'http://storage.opsware.com',
     'xmlns:acm'=>'http://acm.opsware.com',
     'xmlns:windows.pkg'=>'http://windows.pkg.opsware.com',
     'xmlns:nas'=>'http://nas.opsware.com',
     'xmlns:solaris.pkg'=>'http://solaris.pkg.opsware.com',
     'xmlns:virtualization'=>'http://virtualization.opsware.com',
     'xmlns:savedsearch'=>'http://savedsearch.opsware.com',
     'xmlns:aix.pkg'=>'http://aix.pkg.opsware.com',
     'xmlns:hpux.pkg'=>'http://hpux.pkg.opsware.com',
     'xmlns:compliance'=>'http://compliance.opsware.com',
     'xmlns:fido'=>'http://fido.opsware.com',
     'xmlns:report'=>'http://report.opsware.com',
     'xmlns:mgmtservice.ilo'=>'http://mgmtservice.ilo.opsware.com',
     'xmlns:swmgmt'=>'http://swmgmt.opsware.com',
     'xmlns:atm'=>'http://atm.opsware.com',
     'xmlns:busapp'=>'http://busapp.opsware.com',
     'xmlns:device'=>'http://device.opsware.com',
     'xmlns:script'=>'http://script.opsware.com',
     'xmlns:reportresult'=>'http://reportresult.opsware.com',
     'xmlns:chef.pkg'=>'http://chef.pkg.opsware.com',
     'xmlns:sitemap'=>'http://sitemap.opsware.com',
     'xmlns:folder'=>'http://folder.opsware.com',
     'xmlns:smo'=>'http://smo.opsware.com',
     'xmlns:args.fido'=>'http://args.fido.opsware.com',
     'xmlns:apx.fido'=>'http://apx.fido.opsware.com',
     'xmlns:mgmtservice.v12n'=>'http://mgmtservice.v12n.opsware.com',
     'xmlns:mgmtservice'=>'http://mgmtservice.opsware.com',
     'xmlns:vmware.v12n'=>'http://vmware.v12n.opsware.com',
     'xmlns:server'=>'http://server.opsware.com',
     'xmlns:locality'=>'http://locality.opsware.com',
     'xmlns:wsdl'=>'http://schemas.xmlsoap.org/wsdl/',
     'xmlns:wsdlsoap'=>'http://schemas.xmlsoap.org/wsdl/soap/',
     'xmlns:xsd'=>'http://www.w3.org/2001/XMLSchema'}
  end

  def initialize opts
    fail unless opts.is_a? Hash
    @opts = opts
    @debug = @opts[:debug]
    return unless @opts[:host] # for testcases
    @cookie = @opts[:cookie]
    @lock = Mutex.new
    @http = nil
    restart_http
  end

  def host
    @opts[:host]
  end

  def close
    @http.finish rescue IOError
  end

  def restart_http
    begin 
      @http.finish if @http
    rescue Exception => ex
      puts "WARNING: Ignoring exception: #{ex.message}"
      puts ex.backtrace.join("\n")
    end
    @http = Net::HTTP.new(@opts[:host], @opts[:port], @opts[:proxyHost], @opts[:proxyPort])

    if @opts[:ssl]
      require 'net/https'
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @http.cert = OpenSSL::X509::Certificate.new(@opts[:cert]) if @opts[:cert]
      @http.key = OpenSSL::PKey::RSA.new(@opts[:key]) if @opts[:key]
    end
    @http.set_debug_output(STDERR) if $DEBUG
    @http.read_timeout = 1000000
    @http.open_timeout = 60
    def @http.on_connect
      @socket.io.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)
    end
    @http.start
  end

  def soap_envelope
    xsd = 'http://www.w3.org/2001/XMLSchema'
    env = 'http://schemas.xmlsoap.org/soap/envelope/'
    xsi = 'http://www.w3.org/2001/XMLSchema-instance'
    xml = Builder::XmlMarkup.new :indent => 0
    attributes={'xmlns:xsd' => xsd, 'xmlns:env' => env, 'xmlns:xsi' => xsi}
    xml.tag!('env:Envelope', attributes.merge(namespaces)) do
      xml.tag!('env:Body') do
        yield xml if block_given?
      end
    end
    xml
  end

  def request action, body, service_path
    headers = { 'content-type' => 'text/xml; charset=utf-8', 'SOAPAction' => action }
    headers['cookie'] = @cookie if @cookie

    if @debug
      $stderr.puts "Request:"
      $stderr.puts body
      $stderr.puts
    end

    start_time = Time.now
    response = @lock.synchronize do
      begin
        request=Net::HTTP::Post.new(service_path, initheader=headers)
        request.body=body
        request.basic_auth @opts[:user],@opts[:password]
        @http.request(request)
      rescue Exception
        restart_http
        raise
      end
    end
    end_time = Time.now
    
    if response.is_a? Net::HTTPServiceUnavailable
      raise "Got HTTP 503: Service unavailable"
    end

    self.cookie = response['set-cookie'] if response.key? 'set-cookie'

    nk = Nokogiri(response.body)
    if @debug
      $stderr.puts "Response (in #{'%.3f' % (end_time - start_time)} s)"
      $stderr.puts nk
      $stderr.puts
    end

    [nk.xpath('//soapenv:Body/*').select(&:element?).first, response.body.size]
  end
end
