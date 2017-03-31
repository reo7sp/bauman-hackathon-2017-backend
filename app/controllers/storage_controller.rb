class StorageController < ApplicationController
  include AuthConcern

  before_action :auth!

  def info
    render json: { last_modified: File.mtime(user_path) }
  rescue IOError
    render json: { error: 'file not found' }, status: :not_found
  end

  def get
    send_file(user_path, filename: File.basename(params[:path]))
  rescue ActionController::MissingFile
    render json: { error: 'file not found' }, status: :not_found
  end

  def set
    FileUtils.mkdir_p(user_root)
    File.binwrite(user_path, params[:data])
    render json: { ok: 1 }
  rescue SystemCallError, IOError
    render json: { error: 'io' }, status: :internal_server_error
  end

  def delete
    File.delete(user_path)
    render json: { ok: 1 }
  rescue SystemCallError, IOError
    render json: { error: 'io' }, status: :internal_server_error
  end

  private

  def user_root
    File.join(Rails.configuration.x.storage_root, Digest::MD5.hexdigest(@user.email))
  end

  def user_path(path = params[:path])
    File.join(user_root, Digest::MD5.hexdigest(path))
  end
end
