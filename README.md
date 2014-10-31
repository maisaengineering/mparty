mparty
======

### Initial Setup

We need to run:
 * `bundle exec rake db:create` - Create database
 * `bundle exec rake db:migrate` - Migrate database
 * `bundle exec rake db:seed` - Seed data
 * `bundle exec rake spree_sample:load` - Load sample data
 * `bundle exec rake spree_roles:permissions:populate` - To populate user and admin roles with their permissions
 
### Reset database on heroku
 * `heroku pg:reset postgres` OR
 * `heroku pg:reset DATABASE_URL` then follow above steps from migrate

#### Mailer Configuration

* go to spree admin/configuration and click on 'Mail method smpt settings' then add below settings

```sh
DOMAIN    : maisasolutions.com
MAIL HOST : smtpout.secureserver.net
PORT      : 80
SECURE CONNECTION TYPE : None
AUTHENTICATION TYPE : plain
USERNAME : labs@maisasolutions.com
Pass     : XXXXX
```
######be sure to check 'ENABLE MAIL DELIVERY'
* Sample screenshot added to Rails.root/doc/spree-smpt-settings-example.png

