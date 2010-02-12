require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Expurrel" do
  
  it "should load the text file into a constant" do    
    Expurrel::PROVIDERS.include?('bit.ly').should be true
  end
  
  it "should not decode a normal url" do
    e = Expurrel.new('http://www.jaapvandermeer.com/test')
    e.decode.should eql('http://www.jaapvandermeer.com/test')
  end
  
  it "should decode a url that is on the tinyurlproviders.txt list" do
    e = Expurrel.new('http://bit.ly/aanv6P')
    e.decode.should eql('http://www.jaapvandermeer.com/2010/02/12/introducing-myself/')
  end


  it "should decode a url from bacn.me" do
    e = Expurrel.new('http://bacn.me/xg4')
    e.decode.should eql('http://www.jo.com')
  end
end
