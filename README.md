# User JSON API

A quick API project built in rails

Tasks
* Create a user resource with sensible fields including a password that is stored appropriately without using bcrypt.
* Implement soft delete for models, such that if included the row is flagged as deleted instead of deleted.
* Apply to the user model with a default scope so that deleted rows are not queried.
* Allow API endpoints for the user resource to CRUD a user. User's can only update their own user via a password.
