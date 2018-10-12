class QueueItems
  attr_accessor :queue, :source, :logger

  def initialize(source)
    @source = source
    @logger = Kawari::Logger.new('QueueItems')
    @queue = []
  end

  def add(item, sub)
    queue.push(item)
    sub.increment(item.classifier)
  end

  def download
    queue.each do |item|
      logger.info('Pushing :: ' + item.title + ' :: ' + item.link)
      Kawari::Adapter::RabbitMQ.publish(item.to_hash.to_json)
      Kawari::Models::Torrent.new(source_id: source[:source_id], name: item.title, t_id: item.id, downloaded: true).save
      # torrent = Torrent.where(source_id: source[:source_id], name: item.title, t_id: item.id).first
      # torrent.downloaded = true
      # torrent.save
    end
  end
end
