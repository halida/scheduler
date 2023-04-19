class Users::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :callback

  include OidcHelper

  skip_before_action :authenticate_user!, :only => [:new, :callback]
  def new
    redirect_to authorization_uri, allow_other_host: true
  end

  def callback
    oidc_client.authorization_code = params[:code]
    access_token = oidc_client.access_token!
    return redirect_to(root_url) if access_token.blank?

    info  = oidc_user_info(access_token)
    email = info.raw_attributes['email']
    Rails.logger.info("sso user email: #{email}")
    user  = User.find_by_email(email)
    if user.blank?
      if Settings.oidc.create_user and email.end_with?("@#{ Settings.oidc.create_user_domain }")
        Rails.logger.info("create scheduler user for: #{email}")
        user = User.create(username: email, email: email)
      else
        render plain: "You can't login to scheduler"
        return
      end
    end
    Rails.logger.info("scheduler user id: #{user.try(:id)}, email: #{user.try(:email)}")

    sign_in(user)

    redirect_to root_path
  end

  def destroy
    session.clear
    redirect_to Settings.oidc.signoff_url
  end
end
