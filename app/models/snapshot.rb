class Snapshot < ActiveRecord::Base
  def self.generate(ends_at = DateTime.now)
    generate_between(Tweet.chronological.first.created_at, ends_at)
  end

  def self.generate_between(begins_at, ends_at)
    imageService = TweetImageService.new(
      begins_at: begins_at,
      ends_at: ends_at)

    filename = generate_filename

    imageService.save "/tmp/#{filename}"
    upload = upload_snapshot filename
    create(url: upload.public_url,
           tweet_count: Tweet.where(created_at: (begins_at..ends_at)).count,
           begins_at: begins_at,
           ends_at: ends_at)
  end

  private

  class << self
    def generate_filename
      "snapshot_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}.png"
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
end
