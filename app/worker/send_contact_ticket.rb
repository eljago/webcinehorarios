class SendContactTicket
  
  @queue = :send_contact_ticket_queue
  
  def self.perform(name, from, subject, content)
    ContactMailer.cinehorarios_contacto(name, from, subject, content).deliver
  end
end