require "uri"

module Tire

  class Configuration

    def self.url(value=nil)
      @url = (value ? value.to_s.gsub(%r|/*$|, '') : nil) || @url || ENV['ELASTICSEARCH_URL'] || "http://localhost:9200"
    end
    
    def self.global_index_name(name=nil)
      return @global_index_name = name.to_s.gsub(%r|/*$|, '') if name
      @global_index_name || nil
    end
    
    def self.index_url(value=nil)
      if value
        @index_url = value.to_s.gsub(%r|/*$|, '')
        uri = URI(@index_url)
        self.url( "http://#{uri.host}" )
        self.global_index_name( uri.path[1..-1] )
      end
      @index_url || nil
    end

    def self.client(klass=nil)
      @client = klass || @client || HTTP::Client::RestClient
    end

    def self.wrapper(klass=nil)
      @wrapper = klass || @wrapper || Results::Item
    end

    def self.logger(device=nil, options={})
      return @logger = Logger.new(device, options) if device
      @logger || nil
    end

    def self.reset(*properties)
      reset_variables = properties.empty? ? instance_variables : instance_variables.map { |p| p.to_s} & \
                                                                 properties.map         { |p| "@#{p}" }
      reset_variables.each { |v| instance_variable_set(v.to_sym, nil) }
    end

  end

end
