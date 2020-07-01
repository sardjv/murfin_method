class Performance
  # Pass a block to get data on its performance:
  # Performance.test { object.method }
  def self.test
    log 'test'
    time { yield }
    memory { yield}
  end

  def self.time
    log "TIME: #{ Benchmark.realtime { yield }.round(2) } seconds"
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

  def self.line_break
    Rails.logger.info '---------------------------------------'
  end

  def self.log
    ActiveSupport::Logger.new(STDOUT)
  end
end
