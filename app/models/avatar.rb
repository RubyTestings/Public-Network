class Avatar < ActiveRecord::Base
  URL_STUB = "/images/avatars"
  DIRECTORY = File.join("public","images","avatars")

  def initialize( user , image = nil )
    @user = user
    @image = image
    Dir.mkdir(DIRECTORY) unless File.directory?(DIRECTORY)
  end

  def exists?
    File.exists?(File.join(DIRECTORY,filename))
  end

  alias exist? exists?

  def url
    "#{URL_STUB}/#{filename}"
  end

  def thumbnail_url
    "#{URL_STUB}/#{thumbnail_name}"
  end

  private

  def filename
    "#{@user.screen_name}.png"
  end

  def thumbnail_name
    "#{@user.screen_name}_thumbnail.png"
  end

end
