namespace :snapshot do
  desc "Generate snapshots from the first tweet to every day up until today"
  task :everyday, [:areaArg] => :environment do |t, args|
    area = args[:areaArg] || :manhattan
    puts "Generating everyday for #{area}"

    start = Tweet.chronological.first.created_at
    days = (Time.zone.now - start).to_i / 1.day
    days.times do |difference|
      SnapshotFactory.new(area).generate(start + (difference + 1).days)
    end
  end

  desc "Generate a snapshot for the passed area at the current time"
  task :generate, [:areaArg] => :environment do |t, args|
    area = args[:areaArg]
    raise ArgumentError, "Area argument (nyc, manhattan, etc) required" unless area.present?

    puts "Generating snapshot for #{area}"
    SnapshotFactory.new(area).generate
  end

  desc "Generate snapshots for all areas"
  task :generate_all => :environment do |t, args|
    Area::NAMES.each do |area|
      puts "Generating snapshot for #{area}"
      SnapshotFactory.new(area).generate
    end
  end

  desc "Update images of existing snapshots"
  task :update_images => :environment do
    Snapshot.find_each do |snapshot|
      snapshot.update_image!
    end
  end
end
