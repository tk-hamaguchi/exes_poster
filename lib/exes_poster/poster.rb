module ExesPoster
  # ExesPoster::Poster
  #
  # @since 0.1.0
  # @author tk.hamaguchi@gmail.com
  #
  module Poster
    def self.included(klass)
      klass.module_eval do
        def self.post(type, message, detail = nil)
          body = {
            message: message,
            '@timestamp' => Time.now.iso8601(3)
          }
          body[:detail] = detail unless detail.nil?

          c = Elasticsearch::Client.new(url: es_url)
          d = c.index(
            index: es_index,
            type: type,
            body: body,
            refresh: true
          )

          d['_id']
        end

        def self.post_exception(e)
          post(
            :exception,
            e.message,
            class: e.class.name,
            backtrace: e.backtrace
          )
        end
      end
    end
  end
end
