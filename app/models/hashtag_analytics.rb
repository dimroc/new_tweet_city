class HashtagAnalytics < ActiveRecord::Base
  has_many :entries,
    -> { order "count DESC" },
    class_name: "HashtagAnalyticsEntry",
    dependent: :destroy

  def self.generate(period, entry_count = 5)
    start_date = 1.send(period).ago
    analytics = HashtagAnalytics.new(period: period)

    Hashtag.select("term, COUNT(id)").
      where("created_at > ?", start_date).
      group("term").
      order("COUNT(id) DESC").first(entry_count).each do |entry|
        print '.'
        analytics.entries.build(
          term: entry.term,
          count: entry.count)
      end

    analytics.save!
    analytics
  end
end
