class Cache

  def self.caching_enabled?
    Rails.application.config.action_controller.perform_caching
  end

  def self.fetch(key, &block)
    if Cache.caching_enabled?
      Rails.cache.fetch(key, &block)
    else
      block.call
    end
  end

  def self.clear_cache
    Rails.cache.clear if Cache.caching_enabled?
  end
end
