namespace :snapshot do
  desc "Generate snapshots from the first tweet to every day up until today"
  task :everyday => :environment do
    start = Tweet.chronological.first.created_at
    days = (Time.zone.now - start).to_i / 1.day
    days.times do |difference|
      Snapshot.generate(start + (difference + 1).days)
    end
  end

  desc "Generate a snapshot for the current time"
  task :generate => :environment do
    Snapshot.generate
  end
end
