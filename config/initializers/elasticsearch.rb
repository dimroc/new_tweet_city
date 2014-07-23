host = ENV['ELASTICSEARCH_URL'] || "http://localhost:9200"
tracer = ::Logger.new(STDERR)
Elasticsearch::Model.client = Elasticsearch::Client.new host: host, tracer: tracer
