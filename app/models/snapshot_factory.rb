class SnapshotFactory
  attr_reader :area

  def initialize(area = :manhattan)
    @area = area
    raise ArgumentError, "Invalid area" unless Area::NAMES.include? area.to_s
  end

  def generate(ends_at = DateTime.now)
    generate_between(Tweet.chronological.first.created_at, ends_at)
  end

  def generate_between(begins_at, ends_at)
    upload = generate_image(begins_at, ends_at)
    Snapshot.create(
      url: upload.public_url,
      area: area,
      tweet_count: Tweet.where(created_at: (begins_at..ends_at)).count,
      begins_at: begins_at,
      ends_at: ends_at)
  end

  def generate_image(begins_at, ends_at)
    imageService = image_class.new(
      begins_at: begins_at,
      ends_at: ends_at)

    filename = generate_filename

    imageService.save "/tmp/#{filename}"
    upload_snapshot filename
  end

  private

  def generate_filename
    "#{area}_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}.png"
  end

  def image_class
    "ImageService::#{area.to_s.camelcase}".constantize
  end

  def upload_snapshot(filename)
    FogService.new.upload(
      "snapshots/#{area}/#{filename}",
      File.open("/tmp/#{filename}"))
  end
end
