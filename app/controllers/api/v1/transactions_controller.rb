class Api::V1::TransactionsController < Api::V1::ApiController
  before_action :set_transaction, only: [:like, :unlike]

  def like
    @transaction.liked_by api_user

    redirect_to api_v1_transaction_path(@transaction)
  end

  def unlike
    @transaction.unliked_by api_user

    redirect_to api_v1_transaction_path(@transaction)
  end

  private

  # context that is by the TransactionResource to generate the value of the 'api_user_voted' attribute
  def context
    {api_user: api_user}
  end

  def set_transaction
    transaction_id = params[:id]
    @transaction = Transaction.find(transaction_id)
  rescue
    error_object_overrides = {title: 'Transaction record not found',
                              detail: "The transaction record identified by #{transaction_id} could not be found."}
    handle_exceptions(JSONAPI::Exceptions::RecordNotFound.new(transaction_id, error_object_overrides))
  end
end
