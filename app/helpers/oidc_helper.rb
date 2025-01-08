module OidcHelper

  private

  def oidc_client
    @client ||= OpenIDConnect::Client.new(
      identifier:     ENV["OIDC_IDENTIFIER"],
      secret:         'secret',
      redirect_uri:   ENV["OIDC_CALLBACK_URL"],
      host:           ENV["OIDC_HOST"],
      authorization_endpoint: '/connect/authorize',
      token_endpoint:         '/connect/token',
      userinfo_endpoint:      '/connect/userinfo',
    )
  end

  def authorization_uri
    session[:state] = SecureRandom.hex(16)
    session[:nonce] = SecureRandom.hex(16)

    ret = oidc_client.authorization_uri(
      scope: oidc_scope,
      state: session[:state],
      nonce: session[:nonce],
      response_type: [:code, :id_token],
      response_mode: 'form_post',
    )

    ret
  end

  def oidc_scope
    eval(ENV["OIDC_SCOPE"])
  end

  def oidc_user_info(_access_token)
    return nil unless _access_token.present?

    access_token = OpenIDConnect::AccessToken.new(
      access_token: _access_token,
      client: oidc_client,
    )

    access_token.userinfo!
  end
end
