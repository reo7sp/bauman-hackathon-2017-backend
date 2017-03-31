class AuthController < ApplicationController
  include AuthConcern

  def login
    @user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
    if @user
      @session = Session.create!(token: rand(2 ** 32).to_s(16), user: @user)
      render json: { token: @session.token }
    else
      render json: { error: 'user not found' }, status: :not_found
    end
  end

  def signup
    @user = User.new(email: params[:email], password: params[:password])
    if @user.save
      @session = Session.create!(token: rand(2 ** 32).to_s(16), user: @user)
      render json: { token: @session.token }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
end
