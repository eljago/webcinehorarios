class Admin::ContactTicketsController < ApplicationController

  def index
    @contact_tickets = ContactTicket.all
  end
  
  def show
    @contact_ticket = ContactTicket.find(params[:id])
  end
end
