tracer = ::Logger.new(STDERR)
Elasticsearch::Model.client = Elasticsearch::Client.new tracer: (ENV['LOUD_ES'] ? tracer : nil)
