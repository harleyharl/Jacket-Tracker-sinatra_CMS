# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app

- [x] Use ActiveRecord for storing information in a database

- [x] Include more than one model class (e.g. User, Post, Category)
      The models I used were User, Jacket, Location and Brand

- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts)
      Users have many jackets, and have many locations through jackets

- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User)
      A jacket belongs to a location and a location belongs to a user

- [x] Include user accounts with unique login attribute (username or email)

- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying

- [x] Ensure that users can't modify content created by other users

- [x] Include user input validations    

- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
      Achieved by storing messages in session hash and clearing with a method i built - clear_errors

- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
