class ContactMailer < ActionMailer::Base

  def cinehorarios_contacto(name, from, subject, content)
    @name = name
    @content = content
    @from = from
    @subject = subject
    mail to: "clonjago@gmail.com", from: from, subject: "[CONTACTO CINE HORARIOS] #{subject}"
  end
end
