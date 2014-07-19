module SearchableTweet
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    index_name "tweets-#{Rails.env}"

    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mappings do
        indexes :screen_name
        indexes :text, analyzer: 'english'
        indexes :created_at, type: 'date'

        indexes :neighborhood do
          indexes :name, index: 'not_analyzed'
          indexes :slug, index: 'not_analyzed'
          indexes :borough, index: 'not_analyzed'
        end
      end
    end

    # Customize the JSON serialization for Elasticsearch
    def as_indexed_json(options={})
      rval = self.as_json(only: [:screen_name, :text, :created_at])
      if neighborhood
        neighborhood_json = {
          neighborhood: {
            name: neighborhood.name,
            slug: neighborhood.slug,
            borough: neighborhood.borough
          }
        }

        rval.merge neighborhood_json
      else
        rval
      end
    end
  end

  module ClassMethods
    def fast_import(options={}, &block)
      neighborhood_cache = Neighborhood.generate_cache
      transform = lambda do |t|
        response = {
          screen_name: t.screen_name,
          text: t.text,
          created_at: t.created_at,
        }

        hood = neighborhood_cache[t.neighborhood_id]
        if hood
          response.merge!({ neighborhood: {
            name: hood.name,
            slug: hood.slug,
            borough: hood.borough
          }})
        end

        { index: { _id: t.id, _score: 1, data: response } }
      end

      import(options.merge({transform: transform}), &block)
    end

    def search_count_in_manhattan(definition)
      query = {
        "size"=>0,
        "query"=>{
          "match"=>{
            "text"=>definition
          }
        },
        "aggs"=>{
          "in_manhattan"=>{
            "filter"=>{ "term"=> { "neighborhood.borough" => "Manhattan" } },
            "aggs"=>{
              "neighborhoods"=>{
                "terms"=>{
                  "field"=>"neighborhood.slug"
                }
              }
            }
          }
        }
      }

      results = Tweet.search(query)
      buckets = results.response.aggregations.in_manhattan.neighborhoods.buckets
      generate_bucket_hash(buckets)
    end

    def search_count_by_location(definition)
      query = {
        "size"=>0,
        "query"=>{
          "match"=>{
            "text"=>definition
          }
        },
        "aggs"=>{
          "boroughs"=>{
            "terms"=>{
              "field"=>"neighborhood.borough"
            },
            "aggs"=>{
              "neighborhoods"=>{
                "terms"=>{
                  "field"=>"neighborhood.slug"
                }
              }
            }
          }
        }
      }

      search_nested_locations(query)
    end

    def search_count_in_hoods(definition)
      query = { match: { text: definition } }
      aggregation = { neighborhoods: { terms: { field: 'neighborhood.slug' } } }
      results = Tweet.search({ query: query, aggs: aggregation }, search_type: 'count')

      generate_bucket_hash(results.response.aggregations.neighborhoods.buckets)
    end

    def search_count_in_boroughs(definition)
      query = { match: { text: definition } }
      aggregation = { boroughs: { terms: { field: 'neighborhood.borough' } } }
      results = Tweet.search(
        { query: query, aggs: aggregation },
        search_type: 'count')

      generate_bucket_hash(results.response.aggregations.boroughs.buckets)
    end

    private

    def generate_bucket_hash(buckets)
      buckets.inject({}) do |memo, term|
        memo[term['key']] = term['doc_count']
        memo
      end
    end

    def search_nested_locations(query)
      results = Tweet.search(query)
      results.response.aggregations.boroughs.buckets.inject({}) do |memo, term|
        memo[term['key']] = {
          count: term['doc_count'],
          neighborhoods: generate_bucket_hash(term['neighborhoods']['buckets'])
        }
        memo
      end
    end
  end
end
