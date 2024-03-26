class UserMailer < ApplicationMailer
  default from: "chesscobra05@gmail.com"
  def send_otp(user, otp)
    @user = user
    @otp = user.otp
    mail(to: @user.email, subject: 'otp for login')
  end

  def booth_allocation(booth, user)
    @booth = booth
    @user = user
    mail(to: @user.email, subject: 'booth allocation')
  end
end
