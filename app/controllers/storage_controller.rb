class StorageController < ApplicationController
  include AuthConcern

  before_action :auth!

  def get
    send_file user_path(params[:path]), filename: File.basename(params[:path])
  rescue ActionController::MissingFile
    render json: { error: 'file not found' }, status: :not_found
  end

  def set
    FileUtils.mkdir_p(user_root)
    File.binwrite(user_path(params[:path]), params[:data])
    render json: { ok: 1 }
  rescue SystemCallError, IOError
    render json: { error: 'io' }, status: :internal_server_error
  end

  private

  def user_root
    File.join(Rails.configuration.x.storage_root, Digest::MD5.hexdigest(@user.email))
  end

  def user_path(path)
    File.join(user_root, Digest::MD5.hexdigest(path))
  end
end
