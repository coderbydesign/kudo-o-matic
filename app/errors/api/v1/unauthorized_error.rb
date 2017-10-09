class Api::V1::UnauthorizedError < JSONAPI::Exceptions::Error
  def initialize(error_object_overrides = {})
    super(error_object_overrides)
  end

  def errors
    [create_error_object(code: '401',
                         status: :unauthorized,
                         title: 'Unauthorized',
                         detail: 'Unauthorized to make this request.')]
  end
end
