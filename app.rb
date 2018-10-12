# encoding: utf-8
require 'kawari'
require 'json'
require_relative 'classifiers/init'
require_relative 'parsers/init'
require_relative 'helpers/init'
require 'pry'

logger = Kawari::Logger.new('Main')

while true
  sources = Kawari::Models::Source.order(Sequel.asc(:source_id))

  sources.each do |source|
    logger.info('Scraping source :: ' + source.name + ' - ' + source.source_id.to_s)

    begin
      queue = QueueItems.new(source)

      my_items = GetItems.by_source(source)

      logger.info('Looking for ' + my_items.size.to_s + ' items')

      feed_items = Feed.get_items(source)

      Classify.by_source(feed_items, source)

      Feed.find_and_queue(queue, source, my_items, feed_items)

      queue.download

    rescue => error
      logger.error('Error occurred :: ' + error.to_s + "\n\n" + error.backtrace.join("\n") + "\n\n")
    end

    logger.info('Finished scraping :: ' + source.name)

  end

  logger.info('Sleeping for 5 minutes')

  sleep 300
end
