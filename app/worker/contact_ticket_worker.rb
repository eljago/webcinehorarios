class ContactTicketWorker
  include Sidekiq::Worker
  sidekiq_options queue: "carrierwave"
  
  def perform(contact_ticket_id)
    contact_ticket = ContactTicket.find(contact_ticket_id)
    puts contact_ticket.id
    ContactMailer.cinehorarios_contacto(contact_ticket).deliver
  end
end