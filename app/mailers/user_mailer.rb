class UserMailer < ActionMailer::Base
  default from: "hongbin.zhou@nuance.com"
  def welcome_email(user)
    @user = user
    @url = 'http://example.com'
    mail(to: @user.email, subject: 'Welcome title!')
  end
end
