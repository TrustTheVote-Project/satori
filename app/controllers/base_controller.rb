class BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :set_page_id

  protected

  def send_csv(csv, filename)
    send_data csv,
      type:         "text/csv; charset=iso-8859-1; header=present",
      disposition:  "attachment; filename=#{filename}"
  end

  private

  def set_page_id
    @page_id = "#{params[:controller]}_#{params[:action]}"
  end

end
