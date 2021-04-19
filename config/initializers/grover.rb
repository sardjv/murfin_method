# frozen_string_literal: true

Grover.configure do |config|
  config.options = {
    executable_path: ENV['CHROMIUM_PATH'],
    format: 'A4',
    margin: {
      top: '10px',
      bottom: '10px'
    },
    print_background: true,
    # viewport: {
    #   width: 1400,
    #   height: 1200
    # },
    prefer_css_page_size: true,
    emulate_media: 'screen',
    bypass_csp: true,
    cache: false,
    timeout: 10_000, # Timeout in ms. A value of `0` means 'no timeout'
    # launch_args: ['--font-render-hinting=medium'],
    # wait_until: 'networkidle2',
    wait_until: 'domcontentloaded'
    # debug: {
    #   headless: false,  # Default true. When set to false, the Chromium browser will be displayed
    #   devtools: true,   # Default false. When set to true, the browser devtools will be displayed.
    # }
  }
end
