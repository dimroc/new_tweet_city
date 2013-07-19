require 'uri'

class TwitterService
  def stream_nyc
    path = "https://stream.twitter.com/1.1/statuses/filter.json"
    query = { locations: "-74.3,40.462,-73.65,40.95" }

    streamer = Proc.new do |chunk|
      json = safe_parse(chunk)
      yield json if json
    end

    Excon.get(
      path,
      headers: headers(path, query),
      query: URI.encode_www_form(query),
      response_block: streamer)
  end

  private

  def headers(path, query)
    {
      'Content-Type' => "application/x-www-form-urlencoded",
      'Authorization' => oauth_header(path, query)
    }
  end

  def oauth_header(path, query)
    options = {
      consumer_key: Settings.twitter.consumer_key,
      consumer_secret: Settings.twitter.consumer_secret,
      token: Settings.twitter.oauth_token,
      token_secret: Settings.twitter.oauth_secret
    }

    SimpleOAuth::Header.new(:get, path, query, options)
  end

  private

  def safe_parse(chunk)
    JSON.parse(chunk)
  rescue => e
    puts e.message
    nil
  end
end
