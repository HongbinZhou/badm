class UserMailer < ActionMailer::Base
  default from: "hongbin.zhou@nuance.com"

  def deliver_report(email)
    @email = email
    @events = Event.all
    @people = Person.all

    mail( :to => @email["to"],
          :subject => @email["subject"])
  end


end
