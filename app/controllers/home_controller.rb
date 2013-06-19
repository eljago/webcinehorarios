class HomeController < ApplicationController
  before_filter :get_page_inicio, only: :index
  before_filter :get_page_contact, only: [:contact, :create_contact]
  
  layout 'webpage'
  
  def index
    @images = @page.images
  end
  
  def contact
    @contact_ticket = ContactTicket.new
  end
  
  def create_contact
    @contact_ticket = ContactTicket.new(params[:contact_ticket])

    if @contact_ticket.save
      # send mail using resque
      Resque.enqueue(SendContactTicket, @contact_ticket.name, @contact_ticket.from, @contact_ticket.subject, @contact_ticket.content)
      
      redirect_to root_path, notice: 'Su mensaje ha sido enviado'
    else
      render 'contact'
    end
  end
  
  private
  
  def get_page_inicio
    @page = Page.find_by_permalink('inicio')
  end
  
  def get_page_contact
    @page = Page.find_by_permalink('contacto')
  end
end
