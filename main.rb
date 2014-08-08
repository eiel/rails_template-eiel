def heroku?
  @heroku ||= yes?('use heroku?')
end

gem_group :development do
  gem "bullet"
  gem "quiet_assets"
  gem "spring-commands-rspec"
end

gem_group :development, :test do
  gem "awesome_print"
  gem "capybara"
  gem "poltergeist"
  gem "rspec-rails", "~> 3.0.0"
  gem "pry-rails"
  gem "pry-byebug"
  gem "pry-rescue"
end

gem_group :production do
  if heroku?
    gem "puma"
    gem "rails_12factor"
  end
end

gem "slim-rails"
gem "newrelic_rpm"

run "rm README.rdoc"
run "bundle install"

generate("rspec:install")
run "bundle exec spring binstub --all"

insert_into_file "spec/rails_helper.rb", before: "RSpec.configure do |config|" do
  <<STRING
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
STRING
end

git :init
git add: "."
git commit: "-a -m 'Initial commit'"
