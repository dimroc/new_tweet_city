Dir.glob('db/seeds/**/*.rb') do |filename|
  puts "loading seed: #{filename}"
  require Rails.root.join filename[0..-4]
end
