module SearchableTweet
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    settings do
      mapping do
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
      index_document if self.published?
    end

    # Customize the JSON serialization for Elasticsearch
    def as_indexed_json(options={})
      self.as_json(
        only: [:screen_name, :text, :created_at],
        include: {
          neighborhood: { only: [:name, :slug, :borough]}
        })
    end
  end
end
