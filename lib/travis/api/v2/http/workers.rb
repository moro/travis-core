module Travis
  module Api
    module V2
      module Http
        class Workers
          include Formats

          attr_reader :workers

          def initialize(workers, options = {})
            @workers = workers
          end

          def data
            {
              'workers' => workers.map { |worker| worker_data(worker) }
            }
          end

          private

            def worker_data(worker)
              {
                'id' => worker.id,
                'name' => worker.name,
                'host' => worker.host,
                'state' => worker.state.to_s,
                'last_seen_at' => format_date(worker.last_seen_at),
                'payload' => worker.payload,
                'last_error' => worker.last_error
              }
            end
        end
      end
    end
  end
end
