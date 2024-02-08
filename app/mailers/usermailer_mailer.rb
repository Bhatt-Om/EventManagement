class UsermailerMailer < ApplicationMailer
  default from: "from@example.com"
  def send_otp(user)
    @user = user
    mail(to: user.email, subject: 'otp for login')
  end
end
