### 1.1.0

(We really are not 1.0 here... breaking changes may occur at any time.)

* Removed Ajax forms
* Removed Datatables
* Implemented a smart_table and smart_form
* Removed excessive testing

### 1.0.7

* Fix bug when no order is passed in datatables
* do not load media helper

### 1.0.6

* add wrapper script for building gems
* misc. stylesheet fixes

### 1.0.5

* add minitest-rails-capybara as a development dependency
* dummy apps use local express_admin
* rename bin/run_tests to test/bin/run

### 1.0.4

* add nil guard for current_user

### 1.0.3

* more integration tests (Capybara)
* fix page load error when Devise is not installed in the parent app
* fix Foundation JS loading error

### 1.0.2

* add integration tests

### 1.0.1

* add responders to gemspec

### 1.0.0

* express_admin:install no longer mounts an engine
* express_admin:install generates an installer for a new express module
* removes previous assumptions (re: User model and having express_admin installed in the parent app)

### 0.3.3

* fix merge errors

### 0.3.2

* draw the route within the app's namespace
* s/controller_file_path/controller_file_name

### 0.3.1

* properly append resources within the ExpressAdmin namespace

### 0.3.0

* add express_admin:scaffold
* add express_admin:common_files (ajax forms)

### 0.2.4

* properly prefix migrations

### 0.2.3

* replace haml with express_templates
* fix bundle install in template.rb

### 0.2.2

* fix deprecation warnings related to Rails 5.0
* bump to ruby 2.2.1
* modify template.rb to fix broken bundle install
* add instructions on how to setup a sample app

### 0.2.1

* update docs (README.md and gemspec)
* add CHANGELOG.md

