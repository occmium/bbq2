Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))

Resque.logger.level = Logger::INFO
# Resque.logger.level = Logger::DEBUG
# Resque.logger.level = Logger::WARN
