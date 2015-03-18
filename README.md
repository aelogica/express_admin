express_admin
=============

ExpressAdmin provides an admin menu framework based on Foundation.  This was developed to be used by other AppExpress components, namely ExpressBlog, ExpressPages, and AppExpress itself.  Visit [appexpress.io](http://appexpress.io) to learn more.


### Sample Application

$ rails new myapp -m https://raw.githubusercontent.com/aelogica/express_admin/master/template.rb


### Scaffolding

$ rails generate express_admin:scaffold agent last_name:string

$ rails destroy express_admin:scaffold agent


### Assumptions

1. Parent app uses Devise.
2. Route is mounted in /admin.

### License

This project rocks and uses MIT-LICENSE.
