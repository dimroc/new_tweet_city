namespace :hashtag do
  desc "Analyze all tweets and generate hashtags"
  task :analyze_hour => :environment do
    HashtagAnalytics.generate('hour')
  end

  desc "Nightly analysis task"
  task :analyze_nightly => [:analyze_day, :analyze_week]

  task :analyze_day => :environment do
    HashtagAnalytics.generate('day')
  end

  task :analyze_week => :environment do
    HashtagAnalytics.generate('week')
  end
end
