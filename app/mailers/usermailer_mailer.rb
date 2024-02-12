class UsermailerMailer < ApplicationMailer
  default from: "from@example.com"
  def send_otp(user, otp)
    @user = user
    @otp = user.otp
    mail(to: @user.email, subject: 'otp for login')
  end
end
