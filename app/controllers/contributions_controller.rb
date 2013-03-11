class ContributionsController < ApplicationController
  respond_to :json

  def index
    @users = User.contributions.limit 10

    respond_with @users
  end

end
