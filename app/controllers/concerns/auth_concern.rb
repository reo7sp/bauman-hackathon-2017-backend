module AuthConcern
  extend ActiveSupport::Concern

  class WrongAuthException < StandardError
  end

  included do
    rescue_from WrongAuthException, with: :render_auth_error
  end

  def auth
    @user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
  end

  def auth!
    raise WrongAuthException unless auth
  end

  def render_auth_error
    render json: { error: 'auth error' }, status: :forbidden
  end
end