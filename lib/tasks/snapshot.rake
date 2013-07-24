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

  desc "Generate a snapshot for the current time"
  task :generate, [:areaArg] => :environment do |t, args|
    area = args[:areaArg] || :manhattan
    puts "Generating everyday for #{area}"
    SnapshotFactory.new(area).generate
  end
end
