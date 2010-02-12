
# SimpleCache is a very simple cache store.
class SimpleCache
  attr_accessor :options
  attr_accessor :store
  
  # Create a new cache store:
  #   SimpleCache.new(:max_size => 100)
  # to set the size of the cache
  def initialize(options = {:max_size => 10})
    @options = options
    @store = {}
  end
  
  # Does it have this key
  def has_key?(key)
    !@store[key].nil?
  end
  
  # Cache an item
  def cache!(key, value)
    if @store.size >= @options[:max_size]
      @store.delete(@store.keys.first)
    end
      
    @store[key] = value
  end
  
  
  # Get value of an key
  def value(key)
    @store[key]
  end
  
end
