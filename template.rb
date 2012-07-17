rvm_current = `rvm current`
rvm_setting, ruby_version, app_name = rvm_current.match(/^[^-]+-(([^-@]+).*@(.+))$/)[1..3]

create_file '.rvmrc', "rvm use --create #{rvm_setting}\nexport HEROKU_APP=#{app_name}-staging"

remove_file 'config/database.yml'

database_file = open('https://raw.github.com/jonallured/rails_template/master/files/database.yml').read
database_config = database_file.gsub /<app_name>/, app_name
create_file 'config/database.example.yml', database_config
create_file 'config/database.yml', database_config

append_file '.gitignore', 'config/database.yml'

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
