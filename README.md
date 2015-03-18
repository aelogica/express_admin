express_admin
=============

ExpressAdmin provides an admin menu framework based on Foundation.  This was developed to be used by other AppExpress components, namely ExpressBlog, ExpressPages, and AppExpress itself.  Visit [appexpress.io](http://appexpress.io) to learn more.


### Sample Application

$ rails new myapp -m https://raw.githubusercontent.com/aelogica/express_admin/master/template.rb


### Scaffolding

$ rails generate express_admin:scaffold agent last_name:string

$ rails destroy express_admin:scaffold agent


### Assumptions

1. Parent app uses Devise and has a User model.
2. Route is mounted in /admin.
3. Parent app uses express_admin.

### License

This project rocks and uses MIT-LICENSE.
