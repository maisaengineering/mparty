mparty
======

### Initial Setup

We need to run:
 * `bundle exec rake db:create` - Create database
 * `bundle exec rake db:migrate` - Migrate database
 * `bundle exec rake db:seed` - Seed data
 * `bundle exec rake spree_sample:load` - Load sample data
 * `bundle exec rake spree_roles:permissions:populate` - To populate user and admin roles with their permissions

