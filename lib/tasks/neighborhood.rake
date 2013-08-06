namespace :neighborhood do
  desc "Generate json for the neighborhoods"
  task :write_json => :environment do
    NeighborhoodFactory.write_json
  end
end
