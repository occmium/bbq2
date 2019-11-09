source 'https://rubygems.org'

ruby '2.5.5'

gem 'omniauth'
gem 'omniauth-vkontakte'
gem 'rails', '~> 5.2.3'
gem 'devise'
gem 'devise-i18n'
# gem 'russian'
gem 'rails-i18n'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'carrierwave'
gem 'rmagick'
gem 'fog-aws'
gem 'mime-types'
gem 'pundit', '~> 1.1'
gem 'resque', '~> 1.27'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'twitter-bootstrap-rails'

group :production do
  gem 'pg'
end

group :test do
  gem 'factory_bot_rails'
end

group :development, :test do
  # набор гемов для написания тестов
  gem 'rspec-rails', '~> 3.4'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  # Гем, который использует rspec, чтобы смотреть наш сайт
  gem 'capybara'
  # Гем, который позволяет смотреть, что видит capybara
  gem 'launchy'
  # ALERT CVE-2019-15587
  gem "loofah", ">= 2.3.1"
  gem 'sqlite3'
  gem 'byebug'#, platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'capistrano', '~> 3.8'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-passenger', '~> 0.2'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-resque', '~> 0.2.3', require: false
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
end
