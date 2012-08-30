app_name = Pathname.new(`pwd`).basename.to_s.strip
rvm_current = `rvm current`.strip
ruby_version = rvm_current.split('-')[1]

create_file '.rvmrc', "rvm use --create #{rvm_current}@#{app_name}\nexport HEROKU_APP=#{app_name}-staging"

remove_file 'config/database.yml'

database_file = open('https://raw.github.com/jonallured/rails_template/master/files/database.yml').read
database_config = database_file.gsub /<app_name>/, app_name
create_file 'config/database.example.yml', database_config
create_file 'config/database.yml', database_config

append_file '.gitignore', 'config/database.yml'

%w[deploy pg_sync rspec].each do |task|
  data = open("https://raw.github.com/jonallured/rake_tasks/master/#{task}.rake").read
  create_file "lib/tasks/#{task}.rake", data
end

gem 'thin'
gem 'decent_exposure'
gem 'haml-rails'

gem_group :development do
  gem 'rails-erd'
  gem 'heroku'
end

gem_group :development, :test do
  gem 'fabrication'
  gem 'pry_debug'
  gem 'pry-rails'
end

gem_group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'rspec-rails'
end

append_file 'Gemfile', "ruby '#{ruby_version}'"

git :init
