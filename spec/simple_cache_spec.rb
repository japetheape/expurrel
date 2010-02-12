require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SimpleCache" do

  it 'should do proper caching' do
    s = SimpleCache.new
    s.cache!('hoi', 'jo')
    s.has_key?('hoi').should be true
    s.value('hoi').should eql('jo')
    
  end
  
  it 'should not exceed the maximum caching' do
    s = SimpleCache.new
    20.times do |i|
      s.cache!(i, 'something to cache')
    end
    s.store.size.should <= 10
  end
  
  
  
end
