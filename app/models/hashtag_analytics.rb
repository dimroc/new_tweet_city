class HashtagAnalytics < ActiveRecord::Base
  belongs_to :neighborhood
  has_many :entries,
    -> { order "count DESC" },
    class_name: "HashtagAnalyticsEntry",
    dependent: :destroy

  def self.generate_for_a_neighborhood(neighborhood, period, entry_count = 5)
    start_date = 1.send(period).ago
    analytics = HashtagAnalytics.new(period: period, neighborhood: neighborhood)

    Hashtag.select("term, COUNT(id)").
      where("created_at > ?", start_date).
      where(neighborhood: neighborhood).
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

  def self.generate_for_a_borough(borough, period, entry_count = 5)
    start_date = 1.send(period).ago
    analytics = HashtagAnalytics.new(period: period, borough: borough)

    Hashtag.select("term, COUNT(id)").
      where("created_at > ?", start_date).
      where(borough: borough).
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

  def self.generate_for_nyc(period, entry_count = 5)
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

  def self.generate_for_boroughs(period, entry_count = 5)
    Borough.names.each do |borough|
      generate_for_a_borough(borough, period, entry_count)
    end
  end

  def all_nyc?
    borough.blank? && neighborhood.blank?
  end
end
