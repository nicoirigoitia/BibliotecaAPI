# frozen_string_literal: true

class LoanMailer < ApplicationMailer
  default from: 'notificaciones@example.com'

  def loan_created_email(user, loan)
    @user = user
    @loan = loan
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Préstamo de Libro Creado')
  end
end
