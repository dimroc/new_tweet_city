namespace :image do
  desc "generate image of manhttan based on tweet coordinates"
  task :manhattan => :environment do
    FileUtils.mkdir_p "tmp/snapshots"
    filename = "tmp/snapshots/manhattan_#{Time.now.to_i}.png"
    puts "Generating #{filename}"
    ImageService::Manhattan.new.save filename
    FileUtils.cp filename, "tmp/snapshots/latest.png"
  end

  desc "generate image of nyc based on tweet coordinates"
  task :nyc => :environment do
    FileUtils.mkdir_p "tmp/snapshots"
    filename = "tmp/snapshots/nyc_#{Time.now.to_i}.png"
    puts "Generating #{filename}"
    ImageService::Nyc.new.save filename
    FileUtils.cp filename, "tmp/snapshots/latest.png"
  end
end
