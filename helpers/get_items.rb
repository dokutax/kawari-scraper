class GetItems
  def self.by_source(source)
    Object.const_get(source.classifier.model_klass).all
  end
end

