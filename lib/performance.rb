class Performance
  # Pass a block to get data on its performance:
  # Performance.test { object.method }
  def self.test
    time { yield }
    memory { yield }
    database { yield }
  end

  def self.time
    log "TIME: #{Benchmark.realtime { yield }.round(2)} seconds"
    line_break
  end

  def self.memory
    log 'MEMORY:'

    report = MemoryProfiler.report do
      yield
    end

    report.pretty_print(
      scale_bytes: true,
      color_output: true,
      detailed_report: false
    )

    line_break
  end

  def self.database
    log 'DATABASE:'

    report = SqlTracker.track do
      yield
    end

    log report.values.map { |query|
      {
        sql: query[:sql],
        count: query[:count],
        duration: query[:duration],
        source: query[:source].uniq
      }
    }.to_yaml

    line_break
  end

  def self.line_break
    Rails.logger.info '---------------------------------------'
  end

  def self.log(string)
    ActiveSupport::Logger.new(STDOUT).info string
  end
end
