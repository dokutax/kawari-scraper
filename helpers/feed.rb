require 'rest-client'

class Feed
  @@logger = nil

  def self.logger
    @@logger ||= Kawari::Logger.new('Feed')
  end

  def self.get_items(source)
    klass = Object.const_get(source.parser.klass)
    feed = Kawari::Download.get(source.url)
    parse = klass.new(feed)
    parse.parse
    parse.to_items
  rescue => error
    logger.error('Unable to retrieve :: ' + source.name + ' :: error ' + error.to_s)
  end

  def self.find_and_queue(queue, source, my_items, feed_items)
    # multi_save = []
    feed_items.reverse_each do |item|
      #	multi_save.push(presave_item(source, item))
      my_items.each do |my|
        if my.is_match?(item.classifier)
          logger.info('Queueing :: ' + item.title)
          queue.add(item, my)
        end
      end
    end

    # recent_items = get_recent_torrents(source)
    # save_items = multi_save - recent_items
    # Torrent.multi_insert(save_items)
  end

  def self.presave_item(source, item)
    item.to_torrent(source)
  end

  def self.get_recent_torrents(source)
    Kawari::Models::Torrent.where(source_id: source[:source_id]).order(Sequel.desc(:ctime)).limit(250).map do |t|
      {}.tap do |item|
        item[:source_id] = t.source_id
        item[:title] = t.title
        item[:t_id] = t.t_id
        item[:downloaded] = false
      end
    end
  end
end
