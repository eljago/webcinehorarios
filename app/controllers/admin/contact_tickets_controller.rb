class Admin::ContactTicketsController < ApplicationController

  def index
    @contact_tickets = ContactTicket.order('created_at DESC').page(params[:page]).per_page(10)
  end
  
  def show
    @contact_ticket = ContactTicket.find(params[:id])
  end
  
  def create
    @contact_ticket = ContactTicket.new(contact_ticket_params)
    if @contact_ticket.save
      ContactMailer.cinehorarios_contacto(@contact_ticket).deliver
      redirect_to root_url, notice: 'Muchas gracias por ponerse en contacto con nosotros.'
    else
      session[:contact_ticket] = @contact_ticket
      redirect_to root_url(anchor: "contact"), flash: { error: "Llene los campos correctamente" }
    end
  end
  
  private
  
  def contact_ticket_params
    params.require(:contact_ticket).permit :content, :from, :name, :subject
  end
end
