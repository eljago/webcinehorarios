class Admin::ContactTicketsController < ApplicationController

  def index
    @contact_tickets = ContactTicket.all
  end
  
  def show
    @contact_ticket = ContactTicket.find(params[:id])
  end
  
  def create
    @contact_ticket = ContactTicket.new(params[:contact_ticket])
    if @contact_ticket.save
      # send mail using resque
      # Resque.enqueue(SendContactTicket, @contact_ticket.name, @contact_ticket.from, @contact_ticket.subject, @contact_ticket.content)
      
      ContactMailer.cinehorarios_contacto(@contact_ticket).deliver
      
      redirect_to root_url, notice: 'Su mensaje ha sido enviado exitosamente'
    else
      session[:contact_ticket] = @contact_ticket
      redirect_to root_url(anchor: "contacto"), flash: { error: "Llene los campos correctamente" }
    end
  end
end
