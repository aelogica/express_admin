Feature: Developer creates a module
  As a Developer building a new Express module
  I want to use express_admin's generators
  So that I focus on building awesome features

Scenario: express_admin:install
  Given the module express_invoices does not exist
  When I create a new express_invoices module
   And I add the private gem source
   And I add express_admin to express_invoices
   And I install express_admin
  Then the admin layout should exist

Scenario: express_admin:scaffold
  Given the module express_invoices does not exist
  When I create a new express_invoices module
   And I add the private gem source
   And I add express_admin to express_invoices
   And I install express_admin
   And I scaffold invoices
  Then the invoice model should exist