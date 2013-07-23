class SnapshotFactory
  attr_reader :area

  def initialize(area = :manhattan)
    @area = area
  end

  def generate(ends_at = DateTime.now)
    generate_between(Tweet.chronological.first.created_at, ends_at)
  end

  def generate_between(begins_at, ends_at)
    imageService = image_class.new(
      begins_at: begins_at,
      ends_at: ends_at)

    filename = generate_filename

    imageService.save "/tmp/#{filename}"
    upload = upload_snapshot filename
    Snapshot.create(
      url: upload.public_url,
      area: area,
      tweet_count: Tweet.where(created_at: (begins_at..ends_at)).count,
      begins_at: begins_at,
      ends_at: ends_at)
  end

  private

  def generate_filename
    "#{area}_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}.png"
  end

  def image_class
    "ImageService::#{area.to_s.camelcase}".constantize
  end

  def upload_snapshot(filename)
    connection = Fog::Storage.new({
      provider: 'AWS',
      aws_access_key_id: Settings.aws.s3_key,
      aws_secret_access_key: Settings.aws.s3_secret
    })

    directory = connection.directories.get(Settings.aws.bucket)
    directory.files.create(
      key: "snapshots/#{filename}",
      body: File.open("/tmp/#{filename}"),
      public: true)
  end
end
