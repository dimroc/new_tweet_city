class FogService
  def upload(cloud_path, io)
    directory.files.create(
      key: cloud_path,
      body: io,
      public: true)
  end

  def delete(cloud_path)
    directory.files.get(cloud_path).destroy
  end

  def directory
    @directory ||= connection.directories.get(Settings.aws.bucket)
  end

  def connection
    @connection ||= Fog::Storage.new({
      provider: 'AWS',
      aws_access_key_id: Settings.aws.s3_key,
      aws_secret_access_key: Settings.aws.s3_secret
    })
  end
end
