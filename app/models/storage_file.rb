class StorageFile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :user, presence: true
  validates :path, presence: true, uniqueness: true

  after_create do |file|
    FileUtils.mkdir_p(File.dirname(file.abs_path))
    File.write(file.abs_path, '')
  end

  after_destroy do |file|
    File.delete(file.abs_path)
  end

  def abs_path
    File.join(Rails.configuration.x.storage_root, path)
  end

  def updated_at
    File.mtime(abs_path).to_i
  end

  def write(data)
    File.binwrite(abs_path, data)
  end
end
