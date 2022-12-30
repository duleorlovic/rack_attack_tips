# https://github.com/duleorlovic/rack_attack_tips/blob/main/test/a/rails_cache_helper.rb
#
# https://kevinjalbert.com/testing-the-use-of-rails-caching/
module RailsCacheHelper
  # Enable cache with config/environments/test.rb and
  #   touch tmp/caching-test.txt
  def with_clean_caching
    Rails.cache.clear
    yield
  ensure
    Rails.cache.clear
  end

  def cache_has_value?(value)
    cache_data.values.map(&:value).any?(value)
  end

  def key_for_cached_value(value)
    cache_data.each_value do |key, entry|
      return key if entry&.value == value
    end
  end

  private

  def cache_data
    Rails.cache.instance_variable_get(:@data)
  end
end
