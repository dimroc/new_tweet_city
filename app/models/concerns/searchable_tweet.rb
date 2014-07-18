module SearchableTweet
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name    "tweets-#{Rails.env}"

    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mappings do
        indexes :screen_name
        indexes :text, analyzer: 'english'
        indexes :created_at, type: 'date'

        indexes :neighborhood, index: 'not_analyzed'
        indexes :neighborhood_slug, index: 'not_analyzed'
        indexes :borough, index: 'not_analyzed'
      end
    end

    after_commit on: [:create] do
      self.__elasticsearch__.index_document
    end

    # Customize the JSON serialization for Elasticsearch
    def as_indexed_json(options={})
      rval = self.as_json(only: [:screen_name, :text, :created_at])
      neighborhood_json = {
        neighborhood: neighborhood.name,
        neighborhood_slug: neighborhood.slug,
        borough: neighborhood.borough
      }

      rval.merge neighborhood_json
    end
  end

  module ClassMethods
    def fast_import(options={}, &block)
      neighborhood_cache = Neighborhood.generate_cache
      transform = lambda do |t|
        response = {
          _id: t.id,
          _score: 1,
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

      import(options.merge({transform: transform}), &block)
    end

    def search_count_in_hoods(definition)
      results = Tweet.search(
        { query: { match: { text: 'knicks' } }, aggregations: { neighborhoods: { terms: { field: 'neighborhood_slug' } } } },
        search_type: 'count')

      results.response.aggregations.neighborhoods.buckets.inject({}) do |memo, term|
        memo[term['key']] = term['doc_count']
        memo
      end
    end

    def search_count_in_boroughs(definition)
      results = Tweet.search(
        { query: { match: { text: 'knicks' } }, aggregations: { boroughs: { terms: { field: 'borough' } } } },
        search_type: 'count')

      results.response.aggregations.boroughs.buckets.inject({}) do |memo, term|
        memo[term['key']] = term['doc_count']
        memo
      end
    end
  end
end
