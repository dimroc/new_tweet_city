class Snapshot < ActiveRecord::Base
  def self.generate
    imageService = TweetImageService.new
    filename = generate_filename

    imageService.save "/tmp/#{filename}"
    upload = upload_snapshot filename
    create(url: upload.public_url, tweet_count: Tweet.count)
  end

  private

  class << self
    def generate_filename
      "snapshot_#{Time.now.strftime("%Y%m%dT%H%M%S%z")}.png"
    end

    def upload_snapshot(filename)
      connection = Fog::Storage.new({
        provider: 'AWS',
        aws_access_key_id: ENV['AWS_S3_KEY'],
        aws_secret_access_key: ENV['AWS_S3_SECRET']
      })

      directory = connection.directories.get('newtweetcity')
      directory.files.create(
        key: "snapshots/#{filename}",
        body: File.open("/tmp/#{filename}"),
        public: true)
    end
  end
end
