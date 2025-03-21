class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create omniauth]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  def omniauth
    @user = User.find_or_create_by(uid: request.env["omniauth.auth"]["uid"], provider: request.env["omniauth.auth"]["provider"]) do |u|
        u.name = request.env["omniauth.auth"]["info"]["name"]
        u.email_address = request.env["omniauth.auth"]["info"]["email"]
        u.password = SecureRandom.hex(10)
    end
    if @user.valid?
      start_new_session_for @user
      redirect_to after_authentication_url
    else
        render :new
    end
  end
end
