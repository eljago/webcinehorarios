class NotifyProblemMailer < ApplicationMailer

  def notify_problem(problem)
    @problem = problem
    mail(to: Rails.application.secrets.report_problem_mail, subject: '[CH] REPORTE DE ERROR')
  end

end
