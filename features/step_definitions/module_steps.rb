Given(/^the module express_invoices does not exist$/) do
  `rm -rf express_invoices`
end

When(/^I create a new express_invoices module$/) do
  stdout_str, stderr_str, status =
    Open3.capture3("cd tmp/aruba && rails plugin new express_invoices --mountable")
  unless status.success?
    rails "unable to create express_invoices"
  end
end

When(/^I add the private gem source$/) do
  `awk -v "n=2" \
       -v "s=source 'https://#{ENV['GEM_SERVER_USERNAME']}:#{ENV['GEM_SERVER_PASSWORD']}@#{ENV['GEM_SERVER_HOST']}/'" \
       '(NR==n) { print s } 1' tmp/aruba/express_invoices/Gemfile > tmp/aruba/out && \
   mv tmp/aruba/out tmp/aruba/express_invoices/Gemfile`
end

When(/^I add express_admin to express_invoices$/) do
   `awk -v "n=21" \
       -v 's=  s.add_dependency "express_admin", "1.0.1"' \
       '(NR==n) { print s } 1' tmp/aruba/express_invoices/express_invoices.gemspec > tmp/aruba/out && \
    mv tmp/aruba/out tmp/aruba/express_invoices/express_invoices.gemspec`
end

When(/^I install express_admin$/) do
  stdout_str, stderr_str, status =
    Open3.capture3("cd tmp/aruba/express_invoices && bundle install && rails g express_admin:install")
  unless status.success?
    raise "Unable to install express_admin"
  end
end

Then(/^the admin layout should exist$/) do
  stdout_str, stderr_str, status =
    Open3.capture3("cd tmp/aruba/express_invoices && ls app/views/layouts/express_invoices/admin.html.et")
  unless status.success?
    raise "Unable to find admin layout"
  end
end

When(/^I scaffold invoices$/) do
  stdout_str, stderr_str, status =
    Open3.capture3("cd tmp/aruba/express_invoices && rails g express_admin:scaffold invoice total:float")
  unless status.success?
    raise "Unable to scaffold invoice"
  end
end

Then(/^the invoice model should exist$/) do
  stdout_str, stderr_str, status =
    Open3.capture3("cd tmp/aruba/express_invoices && ls app/models/express_invoices/invoice.rb")
  unless status.success?
    raise "Unable to find invoice model"
  end
end
