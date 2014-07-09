
git :init
git add: "."
git commit: "-a -m 'Initial commit'"

ruby_version = ask("What ruby version do you want to use ?")
ruby_gemset = ask("What gemset do you want to use ?")

file ".ruby-version", ruby_version
file ".ruby-gemset", ruby_gemset

git add: ".ruby-version"
git add: ".ruby-gemset"
git commit: "-a -m 'Ruby version and gemset'"

gem 'haml'
gem 'modernizr-rails'
gem 'therubyracer'
gem 'foundation-rails'
gem 'devise'
gem 'express_admin', github: 'aelogica/express_admin'

Bundler.clean_system("bundle install")

git add: "Gemfile"
git add: "Gemfile.lock"
git commit: "-m 'Added gems'"

Bundler.clean_system("rails generate foundation:install --force")
git add: "."
git commit: "-a -m 'Installed Foundation'"

Bundler.clean_system("rails generate devise:install && rails generate devise User --force && rake db:migrate")
git add: "."
git commit: "-a -m 'Installed Devise'"

Bundler.clean_system("rails generate express_admin:install --force")
git add: "."
git commit: "-a -m 'Installed ExpressAdmin'"
