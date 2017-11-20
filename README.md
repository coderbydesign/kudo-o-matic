# Kudo-o-Matic™

[![Travis Build Status](https://img.shields.io/travis/kabisa/kudo-o-matic.svg?style=flat-square)](https://travis-ci.org/kabisa/kudo-o-matic.svg?branch=master) [![GitHub release](https://img.shields.io/github/release/kabisa/kudo-o-matic.svg?style=flat-square)](https://github.com/kabisa/kudo-o-matic/releases) [![GitHub license](https://img.shields.io/github/license/kabisa/kudo-o-matic.svg?style=flat-square)](https://github.com/kabisa/kudo-o-matic/blob/master/LICENSE.md)

## Getting Started with the Kudo-o-Matic

### What is the Kudo-o-Matic?
The Kudo-o-Matic is originated from the wish to create a common goal for people and teams who are working on different projects. Goals come in various forms: financial, satisfaction of customers, collaborating and so on...

To keep a good overview we decided to create one 'Kudo Meter', where all these components have been processed in. The goal is not literally a target. It is more like a gauge instead, to stimulate good things.

### How to setup your Kudo-o-Matic locally?

To start using the Kudo-o-Matic, you'll need
* Ruby > 2.0
* Bundler (ruby gem)
* Postgres

##### 1. Clone the repository to your local machine
With HTTPS:
```
git clone https://github.com/kabisa/kudo-o-matic.git
```
With SSH:
```
git clone git@github.com:kabisa/kudo-o-matic.git
```
##### 2. Install bundler
```
gem install bundler
```

##### 3. Install dependencies
```
bundle install
```

##### 4. Add default db settings (change if needed)
```
cp config/database.yml.example config/database.yml
```
##### 5. Create and migrate your database
```
rake db:setup
```
##### 6. Seed your database
```
rake db:seed
```
This will create a standard template with a balance and some goals
##### 7. Environment Variables
Check `env.example` for all environment variables and create a new `.env` file in the root of the project. Now you copy and set the environment variables in your `.env` file
##### 8. Start rails with `rails s`
Now you can view your Kudo-o-Matic at `localhost:3000` from your browser
##### 9. Log in with your Google account
NOTE: If you didn't set the `DEVISE_DOMAIN` ENV variable yet, it will be set to it's default wich is `gmail.com`

Create your account by logging in with your Google+ account
##### 10. Run rake task to promote the first user to admin
In your terminal do
```
rake admin:promote
```
##### 11. You can now view the admin dashboard
Go to http://localhost:3000/admin to see the admin dashboard

## Google API Setup
* Go to 'https://console.developers.google.com'
* Select your project.
* Click 'Enable and manage APIs'.
* Make sure "Contacts API" and "Google+ API" are on.
* Go to Credentials, then select the "OAuth consent screen" tab on top, and provide an 'EMAIL ADDRESS' and a 'PRODUCT NAME'
* Wait 10 minutes for changes to take effect.
* Copy the Google Client ID and Google Client Secret to the Google variables in your `.env` file

## Slack API Setup
Only necessary if you want to connect your Kudo-o-Matic to your Slack team to get notifications from the application

The application will use the Slack Incoming Webhooks API (https://api.slack.com/incoming-webhooks)
* Go to your Slack home page -> Menu -> Configure Apps -> Custom Integrations
* Go to Incoming Webhooks and click 'Add Configuration'
* Choose your channel where the webhook should post notifications (can be changed later)
* Click 'Add Incoming WebHooks Integration
* Copy the 'Webhook URL' and paste it in the `SLACK_WEBHOOK_URL` environment variable in your `.env` file
* As an extra option you can also define `SLACK_CHANNEL` but if you decide to not use this environment variable you should delete the `channnel` option from the Slack notifications in `slack_notifications.rb`

## Mail Notifications
Only necessary if you want to connect your Kudo-o-Matic to your Email to get notifications from the application

The application is using Rails' ActionMailer for this. The default is that if there is no ENV variable configured for this it won't try to send notifications.

* To set up a mail notifier you need to define `MAIL_USERNAME`, `MAIL_PASSWORD` and `MAIL_ADDRESS`.

## Cron jobs

### Mail
The Kudo-o-Matic automatically sends a Kudo-summary email to all users with an email address that have email notifications enabled using rufus-scheduler (thread based Ruby job scheduler).

##### Schedule
Every friday at 10.00 AM.  
Crontab expression: `0 9 * * 5` (in GMT)

### Slack
The Kudo-o-Matic automatically sends a Kudo-reminder message to all users that connected a Slack account.

##### Schedule
Every friday at 10.00 AM.  
Crontab expression: `0 9 * * 5` (in GMT)

## Admin Panel
You can find and add stuff in the database by visiting `localhost:3000/admin`

### Goals
A goal depends on a balance, to set and see a goal on the Kudo Meter you need to set the Goal to the current Balance.
A goal is a reward for the team (for example: Paintball) if they reach a certain amount of ₭udo's that you define.
A goal:
* Has a name
* Has an amount
* Is attached to a Balance

### Transactions
A transaction depends on a balance, to set and see the ₭udo's you gave with a transaction to increment on the Kudo Meter you need to set a Balance with `current: true`.
A transaction:
* Has *1* sender
* Has *0..1* receiver (This can be a random name or a real user)
* Has *1* amount
* Has *1* activity
* Has *0..1* file (jpg, png, gif)
* Has 0..* likes

### Activities
A activity is part of a transaction. A activity:
* Has *0..n* Transactions

### Users
A user is created and can log in with Google+
A user:
* Has a username
* Has an email
* Has a slack username (optional)
* Has admin rights (optional)
* Has *0..n* Transactions

### Balance
A balance is the base of the whole Kudo-o-Matic. A balance:
* Has a name
* Has *0..n* Transactions
* Has *0..n* Goals
* Is the current balance or isn't

### Dependencies
* You can't use the Kudo-o-Matic without a Balance, and `current` should be set to `true` if there is no balance with current yet
* Transactions are always added to the current Balance
* If there are multiple Balances with `current: true` the transaction will be added to the last created Balance
* If you delete users that have transactions the application will crash

![Demo](https://kudo-o-matic-development.s3.amazonaws.com/Screenshot%202017-07-14%2015.17.38.png)
