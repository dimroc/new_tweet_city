module SearchableTweet
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name    "tweets-#{Rails.env}"

    settings do
      mappings dynamic: false do
        indexes :screen_name
        indexes :text, analyzer: 'english'
        indexes :created_at, type: 'date'

        indexes :neighborhood do
          indexes :name
          indexes :slug
          indexes :borough
        end
      end
    end

    after_commit on: [:create] do
      self.__elasticsearch__.index_document
    end

    # Customize the JSON serialization for Elasticsearch
    def as_indexed_json(options={})
      self.as_json(
        only: [:screen_name, :text, :created_at],
        include: {
          neighborhood: { only: [:name, :slug, :borough]}
        })
    end

    def self.fast_import
      neighborhood_cache = Neighborhood.generate_cache
      transform = lambda do |t|
        response = {
          _id: t.id,
          screen_name: t.screen_name,
          text: t.text,
          created_at: t.created_at,
        }

        hood = neighborhood_cache[t.neighborhood_id]
        if hood
          response.merge!({
            neighborhood: hood.name,
            neighborhood_slug: hood.slug,
            borough: hood.borough
          })
        end

        { index: response }
      end

      import transform: transform
    end
  end
end
