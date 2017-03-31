class AuthController < ApplicationController
  include AuthConcern

  before_action :auth!, only: [:register_device]

  def register_device
    # TODO: sms
    render json: { ok: 1 }
  end

  def signup
    @user = User.new(email: params[:email], password: params[:password])
    if @user.save
      render json: { ok: 1 }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
end
