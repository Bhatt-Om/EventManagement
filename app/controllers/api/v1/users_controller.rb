class Api::V1::UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!
  skip_before_action :verify_authenticity_token

  def app_creds
    client_id = Doorkeeper::Application.first.uid
    render json: { message: 'client credentials', client_id: client_id, success: true }, status: :ok
  end

  def find_user
    if params[:access_token]
      user = User.find_by(id: Doorkeeper::AccessToken.find_by(token: params[:access_token])&.resource_owner_id)
      if user
        render json: { message: 'user details', user: user }, status: :ok
      else
        render json: { message: 'User not found', success: false }, status: 404
      end
    else
      render json: { message: 'Please provide an access token', success: false }, status: 422
    end
  end

  def forgot_password
    user = User.find_by(email: params[:email])
    if user
      user.send_reset_password_instructions
      render json: { message: 'Reset Password instruction sent successfully.', success: true }, status: :ok
    else
      render json: { message: 'User not found', success: false }, status: 404
    end
  end

  def send_otp
    user = User.find_by(id: Doorkeeper::AccessToken.find_by(token: params[:access_token])&.resource_owner_id)
    user.update(otp: rand.to_s[2..5])
    # Uncomment the line below if you have a mailer setup
    # UsermailerMailer.send_otp(user)
    render json: { message: 'OTP sent successfully.', success: true }, status: :ok
  end

  def create
    user = User.new(user_params)
    client_app = Doorkeeper::Application.find_by(uid: params[:client_id])

    return render(json: { error: 'Invalid client ID' }, status: 403) unless client_app

    if user.save
      access_token = Doorkeeper::AccessToken.create!(
        resource_owner_id: user.id,
        application_id: client_app.id,
        refresh_token: generate_refresh_token,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: ''
      )

      render(json: {
               user: {
                 user: user,
                 access_token: access_token.token,
                 token_type: 'bearer',
                 expires_in: access_token.expires_in,
                 refresh_token: access_token.refresh_token,
                 created_at: access_token.created_at.to_time.to_i
               },
               message: 'User created successfully.',
               success: true
             }, status: :created)
    else
      render(json: { error: user.errors.full_messages, success: false }, status: 422)
    end
  end

  def login
    user = User.authenticate!(params[:email], params[:password])

    if user
      token = Doorkeeper::AccessToken.create!(
        application_id: Doorkeeper::Application.find_by(uid: params[:client_id]).id,
        resource_owner_id: user.id,
        expires_in: Doorkeeper.configuration.access_token_expires_in,
        scopes: Doorkeeper.configuration.default_scopes
      )

      render(json: {
               user: {
                 email: user.email,
                 role: user.role,
                 access_token: token.token,
                 expires_in: token.expires_in,
                 success: true
               },
               message: 'Login successful.',
               success: true
             })
    else
      render json: { message: 'Invalid credentials', success: false }, status: 401
    end
  end

  def update_profile
    if params[:access_token]
      user = User.find_by(id: Doorkeeper::AccessToken.find_by(token: params[:access_token])&.resource_owner_id)
      user.avatar.attach(user_params["avatar"]) if user_params["avatar"]
      user.aadhar_card.attach(user_params["aadhar_card"]) if  user_params["aadhar_card"]
    
      if user.update(user_params.except(:avatar, :aadhar_card))
        render json: { message: 'Profile updated successfully.', success: true }, status: 200
      else
        render json: { message: 'Unable to update profile.', errors: user&.errors&.full_messages, success: false }, status: 422
      end
    else
      render json: { message: 'Please provide an access token.', success: false }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :mobile_number, :email, :password, :role, :points, :redeemed, :location, :residential_address, :avatar, :aadhar_card)
  end

  def generate_refresh_token
    loop do
      token = SecureRandom.hex(32)
      break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
    end
  end
end
