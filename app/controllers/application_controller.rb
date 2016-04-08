class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate

  protected

  def authenticate
    if ENV['HTTP_AUTH'] =~ %r{(.+)\:(.+)}
     authenticate_or_request_with_http_basic("Kudo-o-Matic™") do |name, password|
        ActiveSupport::SecurityUtils.variable_size_secure_compare(name, $1) &
          ActiveSupport::SecurityUtils.variable_size_secure_compare(password, $2)
      end
    end
  end
end
