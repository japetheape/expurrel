require 'open-uri'
require 'net/http'
require 'simple_cache'

# Expurrel is a tiny url that can be decoded.
class Expurrel
  PROVIDERS = []
  PROVIDERS_LIST_FILE = File.join(File.dirname(__FILE__), '..', 'tinyurlproviders.txt')
  
  
  @@cache = SimpleCache.new(:max_size => 1000)
  
  # Give expurrel a new url 
  def initialize(url)
    @url = url
  end
  
  
  # This method checks first if it's a tiny url domain from the list. 
  # 1. Is it a tinyurl?
  # 2. It is cached? (tinyurls won't change we can cache forever)
  # 3. Decode (slow!), does http request.
  def decode
    return begin
      if !self.is_tiny_url?
        @url
      elsif @@cache.has_key?(@url)
        @@cache.value(@url)
      else
        # TODO add it to the cache
        decoded_url = self.class.reverse_tinyurl(@url)
        @@cache.cache!(@url, decoded_url)
        decoded_url
      end
    end
  end
  
  
  # Is this a tiny url
  def is_tiny_url?
    is_tiny_domain?(self.domain)
  end
  
  
  # Is it a tiny domain?
  def is_tiny_domain?(domain)
    PROVIDERS.each do |l|
      # TODO regular expression matching
      if domain.include?(l)
        return true
      end
    end
    false
  end
  
  
  
  # Get the domain
  def domain
    return @domain if !@domain.nil? 
    unpacked_link = @url.scan(/(https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?/)
    @domain = unpacked_link.first[1]
    return @domain
  end
  
  
  class << self
    
    # Loads the list with providers into
    # the PROVIDERS constant.
    def load_providers!
      return if !PROVIDERS.empty?
      File.open(PROVIDERS_LIST_FILE, "r") .each_line do |line|
        PROVIDERS << line
      end
    end
    
    
    
    
    # Uses the header file sent back to decode 
    # the tiny url. 
    # Trick provided by:
    # http://garrickvanburen.com/archive/how-to-decode-tinyurls-with-ruby
    def reverse_tinyurl(tinyurl)
      Net::HTTP.get_response(URI.parse(tinyurl)).to_hash['location'].to_s
    end
    
  end
end


Expurrel.load_providers!
