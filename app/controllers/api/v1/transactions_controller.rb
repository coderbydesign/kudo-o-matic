class Api::V1::TransactionsController < Api::V1::ApiController
  before_action :set_transaction, only: [:like, :unlike]
  after_action :update_slack_transaction, only: [:like, :unlike]

  def create
    @transaction = TransactionAdder.create_from_api_request(request.headers, params)
    @api_user_voted = api_user.voted_on? @transaction

    render 'api/v1/transactions/create', status: :created
  rescue Exception => e
    error_object_overrides = {title: 'Transaction could not be created', detail: e}
    handle_exceptions(JSONAPI::Exceptions::BadRequest.new(error_object_overrides))
  end

  def like
    @transaction.liked_by api_user

    render 'api/v1/transactions/like', status: :ok
  end

  def unlike
    @transaction.unliked_by api_user

    render 'api/v1/transactions/unlike', status: :ok
  end

  private

  # context that is used by the Transaction JSONAPI::Resource to generate the value of the 'api_user_voted' attribute
  def context
    {api_user: api_user}
  end

  def set_transaction
    transaction_id = params[:id]
    @transaction = Transaction.find(transaction_id)
  rescue
    error_object_overrides = {title: 'Transaction record not found',
                              detail: "The transaction record identified by id #{transaction_id} could not be found."}
    handle_exceptions(JSONAPI::Exceptions::RecordNotFound.new(transaction_id, error_object_overrides))
  end

  def update_slack_transaction
    SlackService.instance.send_updated_transaction(@transaction)
  end
end
