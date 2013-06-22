desc "clearing Rails.cache"

task :clear_cache => :environment do
  Rails.cache.clear
  FileUtils.rm_rf(Dir['public/activities/[^.]*'])
  FileUtils.rm_rf(Dir['public/index.html'])
end
