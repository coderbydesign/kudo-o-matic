# Kudo-o-Matic™

[![Travis Build Status](https://img.shields.io/travis/kabisa/kudo-o-matic.svg?style=flat-square)](https://travis-ci.org/kabisa/kudo-o-matic.svg?branch=master) [![GitHub release](https://img.shields.io/github/release/kabisa/kudo-o-matic.svg?style=flat-square)](https://github.com/kabisa/kudo-o-matic/releases) [![GitHub license](https://img.shields.io/github/license/kabisa/kudo-o-matic.svg?style=flat-square)](https://github.com/kabisa/kudo-o-matic/blob/master/LICENSE.md)

## What is the Kudo-o-Matic?
The Kudo project originated from the wish to create common goals for people and teams who work on different projects in order to *strengthen the team spirit*, *collectively celebrate successes* and *ensure transparency* within an organization.

The Kudo-o-Matic was created to keep track of these goals and the progress towards it. 
Users can reward each other for good deeds by giving Kudos to each other and work together to achieve common goals in the form of Kudo-thesholds.


## Quick start guide
##### Prerequisites
To start using the Kudo-o-Matic, you'll need:
* [Ruby](https://www.ruby-lang.org/) >= 2.3.1
* [Ruby on Rails](http://rubyonrails.org/) >= 5.0.3
* [Bundler](http://bundler.io/)
* [Postgres](https://www.postgresql.org/)

To run the RSpec test suite (not required to run the Kudo-o-Matic), you'll need:
* [PhantomJS](http://phantomjs.org/)
* [Imagemagick](https://www.imagemagick.org/)

##### 1. Clone the GitHub repository
With HTTPS:
```
git clone https://github.com/kabisa/kudo-o-matic.git
```
With SSH:
```
git clone git@github.com:kabisa/kudo-o-matic.git
```

##### 2. Install Bundler
```
gem install bundler
```

##### 3. Install dependencies
```
bundle install
```

##### 4. Copy default database configuration (change if needed)
```
cp config/database.yml.example config/database.yml
```

##### 5. Create and setup database
```
rake db:setup
```

##### 6. Seed database
```
rake db:seed
```
This will add a default configuration to the database with a balance and three goals.

##### 7. Copy environment variables
Copy the environment variables template in the `env.example` to a new `.env` file in the root of the project.  
Following the dependency setup instructions below will help you set these variables.

##### 8. Start Rails server 
```
rails s
```
Now you can view your Kudo-o-Matic at '<http://localhost:3000/>' in your browser.

##### 9. Setup Google API
Follow the Google API setup instructions described below to set up the authentication system.

##### 10. Log in with your Google account
Create your Kudo-o-Matic account by logging in with your Google account.

**NOTE**: Set the `DEVISE_DOMAIN` environment variable to specify the required mail domain (default is gmail.com).

##### 11. Run Rake task to promote the first user to administrator
```
rake admin:promote
```

##### 12. View the administrator dashboard
Go to '<http://localhost:3000/admin>' to view the administrator dashboard.
It provides a simple interface for:
* Creating new entries.
* Editing existing entries.
* Viewing existing entries.
* Destroying existing entries (user entries can't be destroyed, but they can be deactivated and reactivated).

##### 13. Create a company user entry (optional)
It's recommended to create a user entry with the name of organization, so users can give Kudos to the organization as a whole. 
Set the `COMPANY_USER` environment variable and run:
```
rake user:company
```

##### 14. Set up dependencies (optional)
Congratulations, you did just set up the Kudo-o-Matic!  
You can optionally set up the dependencies listed below to get the most out fof your Kudo-o-Matic.

## Google API setup
Follow these instructions to setup the Kudo-o-Matic OAuth 2.0 user authentication system:
* [Create a new Google API project](https://console.developers.google.com).
* Go to 'Library' and make sure 'Contacts API' and 'Google+ API' are enabled.
* Go to 'Credentials', select the 'OAuth consent screen' tab and provide an 'Email address' and a 'Product name'.
* Go to 'Credentials', select the 'Credentials' tab and create a new 'OAuth client ID'.
* Select 'Web application' for the Application type, provide a 'Name' and add an 'Authorized redirect URI'.  
Use '<http://localhost:3000/users/auth/google_oauth2/callback>' for development.
* Set the `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` environment variables.
* Wait 10 minutes for changes to take effect.
* Restart the server.

## Amazon AWS S3 setup
Follow these instructions to setup the Amazon AWS S3 cloud storage service for images attached to Kudo transactions:
* [Create an AWS S3 account](https://aws.amazon.com/resources/create-account/).
* Setup a Amazon S3 Bucket.
* Set the `AWS_S3_HOST_NAME`, `AWS_S3_REGION`, `AWS_S3_BUCKET`, `AWS_S3_BUCKET` and `AWS_SECRET_ACCESS_KEY` environment variables.
* Restart the server.

## Slack API setup
The Kudo-o-Matic can be connected with Slack to enable the following features:
* Receive personalized notifications and reminders.
* Give Kudos with the /kudo command.
* Give Kudos by adding a custom :kudo: reactji to a message ₭udo-o-Matic user.
* Like Kudo transactions using the like button.

Follow these instructions to setup the Kudo-o-Matic Slack integration:
* [Create a new Slack App](https://api.slack.com/apps) and configure the basic information.
* Enable 'OAuth 2.0 & Permissions', select the 'Permission Scopes' `bot`, `commands`, `channels:history`, `chat:write:user`, `chat:write:user`, `reactions:read`, `users:read` and set the 'Request URL'.  
Use '<http://localhost:3000/users/auth/slack/callback>' for development.
* Enable 'Interactive Components' and set the `slack/action` 'Request URL'.  
Use '<http://localhost:3000/slack/action>' for development.
* Enable 'Slash Commands' and create the `/kudo` command, add the usage hint `<amount> to @receiver for <reason>` and set the `slack/command` 'Request URL'.  
Use '<http://localhost:3000/slack/command>' for development.
* Enable 'Event Subscriptions', add the `reaction_added` 'Workspace Event' and set the `slack/reaction` 'Request URL'.  
Use '<http://localhost:3000/slack/reaction>' for development.
* Enable the 'Bot User' with the 'Display name' `Kudo-o-Matic`, the 'Default username' `kudo-o-matic` and turn 'Always Show My Bot as Online' on. 
* Install the Slack App in the Slack Workspace of your organization.
* Set the `SLACK_CLIENT_ID`, `SLACK_CLIENT_SECRET`, `SLACK_VERIFICATION_TOKEN`, `SLACK_ACCESS_TOKEN`, `SLACK_BOT_ACCESS_TOKEN` and `SLACK_CHANNEL` environment variables, provided on the Slack API dashboard.
* Optionally change the value of the `COMPANY_ICON` environment variable to provide your own icon for the footer of Slack messages. 
* Restart the server.

Users can connect their Slack account by signing in to Slack on the settings page.

## Mail setup
The Kudo-o-Matic can automatically send mail notifications when the following events occur:
* When a user joins the Kudo-o-Matic platform.
* When a user receives Kudos (only this user will receive the notification).
* When a Kudo goal is reached.
* Weekly summary mail.

Follow these instructions to enable the Kudo-o-Matic mail notification functionality:
* [Create and new mail account](https://accounts.google.com/SignUp) or use existing mail credentials.
* Set the `MAIL_USERNAME`, `MAIL_PASSWORD` and `MAIL_ADDRESS` environment variables.
* Restart the server.

Users can configure their mail preferences on the settings page. By default, they will receive all mail notifications.

## Kudo-o-Mobile app setup
The Kudo-o-Matic provides a RESTfull API for the [Kudo-o-Mobile](https://github.com/kabisa/kudo-o-matic-frontend) cross-platform [Maji](https://github.com/kabisa/maji) mobile app.
This API is protected with a token based authentication system. Mobile app users retrieve an API-token by signing in to the app. 
  
Follow these instructions to setup the token based authentication system for the mobile app: 
* [Follow the Kudo-o-Mobile README](https://github.com/kabisa/kudo-o-matic-frontend).
* Set the `GOOGLE_CLIENT_ID_KUDO_O_MOBILE_IOS` and `GOOGLE_CLIENT_ID_KUDO_O_MOBILE_ANDROID` environment variables 
(it is possible to add other mobile operating systems by adding new environments variable and editing the AuthenticationController logic).
* Restart the server.

Import the `postman_collection.json` and `postman_environment.json` files into [Postman](https://www.getpostman.com/) to view the API documentation of the Kudo-o-Matic REST API. 

## Scheduled tasks
### Mail
The Kudo-o-Matic automatically sends a Kudo summary mail to all users with an mail address that have email notifications enabled.

##### Schedule
Every friday at 10.00 AM.  
Crontab expression: `0 9 * * 5` (GMT)

**NOTE**: Only works if the mail environment variables are set.

### Slack
The Kudo-o-Matic automatically sends a Kudo reminder message to all users that connected a Slack account.

##### Schedule
Every friday at 11.55 AM.  
Crontab expression: `55 10 * * 5` (GMT)

**NOTE**: Only works if the Slack environment variables are set.

## Entities
### Balance
A *Balance* is the base of the Kudo-o-Matic system. It groups *Goals* together and connects them to *Transactions*.  

A *Balance*:
* Has a name
* Is the current *Balance* or not
* Has *0..n* *Goals*
* Has *0..n* *Transactions*

### Goal
A *Goal* depends on a *Balance*. 
To set and see a *Goal* on the Kudo Meter you need to associate the *Goal* with the current *Balance*.
A *Goal* is a common reward for the organization (for example: paintball) that will be organized if the defined Kudo threshold is exceeded.

A *Goal*:
* Has a name
* Has an amount of Kudos
* Has a date of achievement
* Belongs to *1* *Balance*

### Transaction
A *Transaction* depends on a *Balance*. 
A *User* can reward another *User* for a good deed by creating a Kudo *Transaction*.

A *Transaction*:
* Has a amount of Kudos
* Optionally has an image attachment (JPG, PNG or GIF)
* Optionally has Slack metadata
* Has *1* *Activity*
* Has *1* sender (*User*)
* Has *0..1* receiver (*User*)
* Has *0..** *Votes*

### Activity
An *Activity* is part of a *Transaction*. 
A *Activity* describes the good deed of a *User*.

An *Activity*:
* Has a name (description)
* Belongs to *0..n* *Transactions*

### Vote
A *Vote* depends on a *Transaction* (votable) and a *User* (voter). 
A *User* can like and unlike *Transactions*. 

A *Vote*:
* Belongs to *1* votable (*Transaction*)
* Belongs to *1* voter (*Voter*)
* Optionally has vote metadata

### User
A *User* can create a Kudo *Transaction* to reward another *User* for a good deed.
*Users* work together to achieve common Kudo *Goals*.

A *User*:
* Has a username
* Has an email address
* Optionally has admin rights (optional)
* Optionally has Google user data
* Optionally has Slack user data
* Optionally has an API token
* Has preferences 
* Has *0..n* *Transactions*
* Has *0..n* *Votes*

## How to contribute?
* [Fork the repository](https://github.com/kabisa/kudo-o-matic/fork).
* Create your feature branch (`git checkout -b my-new-feature`).
* Commit your changes (`git commit -am 'Add some new feature'`).
* Push to the branch (`git push origin my-new-feature`).
* [Create a new Pull Request](https://github.com/kabisa/kudo-o-matic/pulls).

## Did you find a bug?
* [Ensure the bug was not already reported](https://github.com/kabisa/kudo-o-matic/issues).
* If you are unable to find an open issue addressing the problem, [open a new one](https://github.com/kabisa/kudo-o-matic/issues/new).   
Be sure to include a title and a clear description, as much relevant information as possible, 
and a code example or an executable test case demonstration the expected behavior that is not occurring. 

## License
Copyright (c) 2016-2017 [Kabisa](https://www.kabisa.nl/). See [LICENSE](https://github.com/kabisa/kudo-o-matic/blob/develop/LICENSE.md) for details.

![Demo](https://kudo-o-matic-development.s3.amazonaws.com/Screenshot%202017-07-14%2015.17.38.png)
