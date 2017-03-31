class StorageController < ApplicationController
  include AuthConcern

  before_action :auth!
  before_action :create_storage_file, only: :set
  before_action :set_storage_file, except: :index

  def index
    @storage_files = StorageFile.where(user: @user)
    if params.has_key?(:since)
      since_time = params[:since].to_i
      @storage_files = @storage_files.to_a.select { |file| file.updated_at >= since_time }
    end
    render 'storage_files/index.json.jbuilder'
  end

  def info
    render 'storage_files/show.json.jbuilder'
  end

  def get
    send_file(@storage_file.abs_path, filename: File.basename(@storage_file.name))
  end

  def set
    @storage_file.write(params[:data])
    render 'storage_files/show.json.jbuilder'
  end

  def delete
    @storage_file.destroy
    render json: { ok: 1 }
  end

  private

  def create_storage_file
    @storage_file = StorageFile.find_by(name: params[:path], user: @user)
    if @storage_file.nil?
      new_path = File.join(Digest::MD5.hexdigest(@user.email), Digest::MD5.hexdigest(params[:path]))
      @storage_file = StorageFile.create!(name: params[:path], user: @user, path: new_path)
    end
  end

  def set_storage_file
    @storage_file ||= StorageFile.find_by!(name: params[:path], user: @user)
  end
end
