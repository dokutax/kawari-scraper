class ClassifyMovie < Classify
  attr_accessor :title, :year, :quality

  def initialize(item)
    process = regex.match(item.title) unless ignore_current?(item)
    if process
      @title = process[1]
      @year = process[2].to_i
      @quality = process[3]

      item.classifier = self
    end
  end

  def ignore_current?(item)
    ignore.select {|term| item.title.include?(term)}.size > 0
  end

  def regex
    Regexp.new('(.*?)\s+(\d{4}).*?(\d+p).*')
  end

  def ignore
    [
        'Half-SBS'
    ]
  end
end
