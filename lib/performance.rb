class Performance
  # Pass a block to get data on its performance:
  # Performance.test { object.method }
  def self.test(&block)
    time(&block)
    memory(&block)
    database(&block)
  end

  def self.time(&block)
    log 'TIME:'

    log "#{Benchmark.realtime(&block).round(2)} seconds"

    log line_break
  end

  def self.memory(&block)
    log 'MEMORY:'

    MemoryProfiler.report(&block).pretty_print(
      scale_bytes: true,
      color_output: true,
      detailed_report: false,
      allocated_strings: 0, # How many allocated strings to list in report.
      retained_strings: 0 # How many retained strings to list in report.
    )

    log line_break
  end

  def self.database(&block)
    log 'DATABASE:'

    log SqlTracker.track(&block).values.map { |query|
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
    ActiveSupport::Logger.new($stdout).info string
  end
end
