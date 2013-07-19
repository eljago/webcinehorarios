class ContactMailer < ActionMailer::Base

  def cinehorarios_contacto(contact_ticket)
    @name = contact_ticket.name
    @content = contact_ticket.content
    @from = contact_ticket.from
    @subject = contact_ticket.subject
    mail to: "contacto@cinehorarios.cl", from: contact_ticket.from, subject: "[CONTACTO CINE HORARIOS] #{contact_ticket.subject}"
  end
end
