module Travis
  module Event
    class Handler

      # Notifies registered clients about various state changes through Pusher.
      class Pusher < Handler
        API_VERSION = 'v1'

        EVENTS = [/^build:(started|finished)/, /^job:test:(created|started|log|finished)/, /^worker:.*/]

        private

          def handle?
            true
          end

          def handle
            Task.run(:pusher, event, payload)
          end

          def payload
            Api.data(object, :for => 'pusher', :type => type, :params => data, :version => API_VERSION)
          end

          def type
            event =~ /^worker:/ ? 'worker' : event.sub('test:', '').sub(':', '/')
          end
      end
    end
  end
end
