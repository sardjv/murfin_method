class Performance
  # Pass a block to get data on its performance:
  # Performance.test { object.method }
  def self.test
    time { yield }
    memory { yield }
    database { yield }
  end

  def self.time
    log 'TIME:'

    log "#{Benchmark.realtime { yield }.round(2)} seconds"

    log line_break
  end

  def self.memory
    log 'MEMORY:'

    MemoryProfiler.report { yield }.pretty_print(
      scale_bytes: true,
      color_output: true,
      detailed_report: false,
      allocated_strings: 0, # How many allocated strings to list in report.
      retained_strings: 0 # How many retained strings to list in report.
    )

    log line_break
  end

  def self.database
    log 'DATABASE:'

    log SqlTracker.track { yield }.values.map { |query|
      {
        sql: query[:sql],
        count: query[:count],
        duration: query[:duration],
        source: query[:source].uniq
      }
    }.to_yaml

    log line_break
  end

  def self.line_break
    '---------------------------------------'
  end

  def self.log(string)
    ActiveSupport::Logger.new(STDOUT).info string
  end
end
