class Api::V1::TransactionsController < Api::V1::ApiController
  before_action :set_transaction_and_user, only: [:update_vote, :destroy_vote]

  def update_vote
    @transaction.liked_by @user

    redirect_to api_v1_vote_path(Vote.last)
  end

  def destroy_vote
    @transaction.unliked_by @user
  end

  private

  def set_transaction_and_user
    transaction_id = params[:id]
    user_id = params[:user_id]

    begin
      begin
        @transaction = Transaction.find(transaction_id)
      rescue
        error_object_overrides = {title: 'Transaction record not found',
                                  detail: "The transaction record identified by #{transaction_id} could not be found."}
        raise JSONAPI::Exceptions::RecordNotFound.new(transaction_id, error_object_overrides)
      end

      begin
        @user = User.find(user_id)
      rescue
        error_object_overrides = {title: 'User record not found',
                                  detail: "The user record identified by #{user_id} could not be found."}
        raise JSONAPI::Exceptions::RecordNotFound.new(user_id, error_object_overrides)
      end
    rescue => e
      handle_exceptions(e)
    end
  end
end
