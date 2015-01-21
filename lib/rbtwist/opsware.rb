# Dimiter Todorov - 2014

module Rbtwist

# A connection to one Opsware Webservices API. Multiple connections to multiple points can be opened.
# NOTE: All Endpoints 'should' be at the same version. However cross-version calls might work. YMMV
  class Opsware < Connection
    # Connect to a Opsware Webservices API SDK endpoint
    #
    # @param [Hash] opts The options hash.
    # @option opts [String]  :host Host to connect to.
    # @option opts [Numeric] :port (443) Port to connect to.
    # @option opts [Boolean] :ssl (true) Whether to use SSL.
    # @option opts [Boolean] :insecure (false) If true, ignore SSL certificate errors.
    # @option opts [String]  :user (detuser) Username.
    # @option opts [String]  :password Password.
    # @option opts [String]  :path (/osapi) SDK endpoint path.
    # @option opts [Boolean] :debug (false) If true, print SOAP traffic to stderr.
    def self.connect opts
      fail unless opts.is_a? Hash
      fail "host option required" unless opts[:host]
      opts[:cookie] ||= nil
      opts[:user] ||= 'detuser'
      opts[:password] ||= ''
      opts[:ssl] = true unless opts.member? :ssl or opts[:"no-ssl"]
      opts[:insecure] ||= true
      opts[:port] ||= (opts[:ssl] ? 443 : 80)
      opts[:path] ||= '/osapi'
      opts[:ns] ||= 'http://common.opsware.com/'
      rev_given = opts[:rev] != nil
      opts[:rev] = '9.1' unless rev_given
      opts[:debug] = (!ENV['RBVTWIST_DEBUG'].empty? rescue false) unless opts.member? :debug
    end

    def close
      super
    end

    def inspect
      "<Opsware Connection(User: #{@opts[:user]}, Host: #{@opts[:host]}:#{@opts[:port]}) #{self.object_id}>"
    end

    # @private
    def pretty_print pp
      pp.text "Opsware(#{@opts[:host]})"
    end

    def self.base_opsware_db
      case Rbtwist.version
        when '9.1'
          'opsware_models_91.db'
        when '10.1'
          'opsware_models_101.db'
        when '10.2'
          'opsware_models_102.db'
        else
          fail "Unable to find DB for SA Version #{Rbtwist.version}"
      end
    end


    add_extension_dir File.join(File.dirname(__FILE__), "opsware")
    #(ENV['RBTWIST_EXTENSION_PATH']||'').split(':').each { |dir| add_extension_dir dir }

    load_vmodl(File.join(File.dirname(__FILE__), "../../model_db/#{self.base_opsware_db}"))
  end

end
