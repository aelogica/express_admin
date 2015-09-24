express_admin
=============

[![Circle CI](https://circleci.com/gh/aelogica/express_admin/tree/master.svg?style=svg&circle-token=a0d588b30ed9e468b3471462ea7fd6ad3fd89916)](https://circleci.com/gh/aelogica/express_admin/tree/master)

ExpressAdmin is a common admin layout based on [Foundation](http://foundation.zurb.com). It also provides tools for creating modules for [AppExpress](http://www.appexpress.io).

![screenshot](https://cloud.githubusercontent.com/assets/5047/6912152/2b06b1d4-d79e-11e4-9765-1a0b095a3c83.png)

Usage
=====

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

Information
===========

License
=======

This project rocks and uses MIT-LICENSE.
