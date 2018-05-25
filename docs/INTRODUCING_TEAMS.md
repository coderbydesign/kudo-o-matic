# Introducing team functions
When introducing the team functions, there is a step that has to be taken in order for the application 
to keep working with the existing data.

## Step 1: Run rake task
After the changes have been deployed to production, the rake task `team:setup` needs to be run.
This task will put all current users, transactions, balances and goals under a new team. The new team
will be named after `ENV['COMPANY_USER']`
