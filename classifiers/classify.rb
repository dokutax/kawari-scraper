class Classify
  def self.by_source(feed_items, source)
    klass = Object.const_get(source.classifier.klass)
    feed_items.each do |item|
      klass.new(item)
    end
  end
end
