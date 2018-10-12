class Btn < Traditional
  def to_items
    xml.xpath('//item').to_a.map {|item| item_klass.new(item.children[1].text.scan(/\[\s+(.*?)\s+\]/).last.first, item.children[7].text)}
  end
end
