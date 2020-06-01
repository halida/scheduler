module Rack
  module OAuth2

    # reference https://github.com/nov/rack-oauth2/blob/a9e9cdb528/lib/rack/oauth2.rb
    def self.http_client(agent_name = "Rack::OAuth2 (#{VERSION})", &local_http_config)
      _http_client_ = HTTPClient.new(
        agent_name: agent_name
      )
      http_config.try(:call, _http_client_)
      local_http_config.try(:call, _http_client_) unless local_http_config.nil?
      _http_client_.request_filter << Debugger::RequestFilter.new if debugging?

      # add by donnie, fix for ssl error
      _http_client_.ssl_config.clear_cert_store
      _http_client_.ssl_config.add_trust_ca('/etc/ssl/certs/ca-certificates.crt')
      # end of donnie

      _http_client_
    end
  end
end
