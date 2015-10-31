# vim: ft=ruby

God.watch do |w|
  w.name = "ntc-listener"
  w.dir = File.join(File.dirname(__FILE__))

  w.start = "bundle exec rake twitter:stream"
  w.log = '/tmp/ntc_listener.log'
  w.keepalive
end
