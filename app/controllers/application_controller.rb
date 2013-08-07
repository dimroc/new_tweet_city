class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_charset

  private

  def set_charset
    response.headers['Content-type'] = 'text/html; charset=utf-8'
  end
end
