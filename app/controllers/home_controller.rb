class HomeController < ApplicationController
  layout 'webpage'
  
  def index
    @opinions = Opinion.order("RANDOM()").limit(4)
    @contact_ticket = ContactTicket.new
    params[:contact_ticket] = session[:contact_ticket] if session[:contact_ticket]
    session[:contact_ticket] = nil
  end
end
