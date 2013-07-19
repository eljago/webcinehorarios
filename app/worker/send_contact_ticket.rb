class SendContactTicket
  
  @queue = :send_contact_ticket_queue
  
  def self.perform(contact_ticket)
    ContactMailer.cinehorarios_contacto(contact_ticket).deliver
  end
end