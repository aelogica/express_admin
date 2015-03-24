express_admin
=============

ExpressAdmin is a common admin layout based on [Foundation](http://foundation.zurb.com). It also provides tools for creating modules for [AppExpress](http://www.appexpress.io).

### Usage

#### 1. Create a mountable engine

    $ rails plugin new awesome --mountable

#### 2. Add this gem

```ruby
gem.add_dependency "express_admin", "~> 1.0"
```

    $ bundle

#### 3. Install

    $ rails generate express_admin:install 

#### 4. Scaffold

    $ rails generate express_admin:scaffold agent last_name:string first_name:string

### License

This project rocks and uses MIT-LICENSE.
