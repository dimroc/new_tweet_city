# encoding: utf-8

##
# Backup Generated: new_tweet_city_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t new_tweet_city_backup [-c <path_to_configuration_file>]
#
if defined?(Backup)
  Backup::Model.new(:new_tweet_city_backup, 'Description for new_tweet_city_backup') do
    ##
    # Split [Splitter]
    #
    # Split the backup file in to chunks of 250 megabytes
    # if the backup file size exceeds 250 megabytes
    #
    split_into_chunks_of 250

    ##
    # PostgreSQL [Database]
    #
    database PostgreSQL do |db|
      db.name               = "new_tweet_city_production"
      db.username           = "ubuntu"
      #db.password           = "my_password"
      db.host               = "localhost"
      db.port               = 5432
      #db.socket             = "/tmp"
      db.socket             = "/var/run/postgresql"
      db.additional_options = ["-xc", "-E=utf8"]
    end

    ##
    # Amazon Simple Storage Service [Storage]
    #
    store_with S3 do |s3|
      s3.access_key_id     = ENV['AWS_S3_KEY']
      s3.secret_access_key = ENV['AWS_S3_SECRET']
      s3.region            = "us-east-1"
      s3.bucket            = ENV['AWS_BUCKET']
      s3.path              = "/backups"
      s3.keep              = 4
    end

    ##
    # Gzip [Compressor]
    #
    compress_with Gzip
  end
end
