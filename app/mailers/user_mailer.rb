class UserMailer < ActionMailer::Base
  default from: "a@a.com"

  def deliver_report(email)
    @email = email
    @events = Event.all
    @people = Person.all

    mail( :to => @email["to"],
          :subject => @email["subject"])
  end


end
