class ClassifyShow < Classify
  attr_accessor :title, :season, :episode

  def initialize(item)
    process = regex.match(item.title) unless ignore_current?(item.title)
    if process
      @title = process[1]
      @season = process[2].to_i
      @episode = process[3].to_i

      item.classifier = self
    end
  end

  def ignore_current?(title)
    includes.select {|term| title.include?(term)}.size == 0
  end

  def regex
    Regexp.new('(.*?)\s+S(\d+).*?E(\d+)\s+.*')
  end

  def includes
    [
        '720p',
        '1080p'
    ]
  end
end
