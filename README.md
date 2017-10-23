MovementMixer

This Sinatra CRUD app allows users to design and manage custom, personalized workout routines by implementing the following functionality:

1). Users can create and log in to their own individual accounts.
2). Logged-in users can design personalized workout plans that comprise several exercise movements.
3). Alternatively, users can create their own exercises to include in a particular workout routine at a later time.
4). A user can view the index of all workout routines, as well as the index of all exercise movements.
5). A user can view all routines designed by a specific user to gain inspiration for his/her own workout plans.
6). A user can include exercise movements created by other users in his/her own workout plans.
7). However, users can only edit and delete routines and movements that they themselves have created.

Installation

1). Fork and clone this repo to your computer.
2). Change directories into the cloned project folder.
3). Install all gem dependencies by running bundle install.
4). Run migrations with the command rake db:migrate to set up the database.
5). Seed your database by running rake db:seed.
6). Run shotgun to start up your application's local server.
7). Navigate to http://localhost:9393 to create your new account and start mixing some moves!

Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jenna424/movement-mixer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.

License

The application is available as open source under the terms of the MIT License.
