class UsersController < ApplicationController
  autocomplete :user, :name

end
