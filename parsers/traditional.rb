require 'nokogiri'

class Traditional
  attr_accessor :data, :xml

  def initialize(data)
    @data = data
  end

  def parse
    @xml = Nokogiri::XML(data)
  end

  def to_items
    xml.xpath('//item').to_a.map {|item| item_klass.new(item.children[1].text, item.children[5].text)}
  end

  def item_klass
    Kawari::Item
  end
end

