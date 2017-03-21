class ContactMailer < ApplicationMailer
  def contact_me_email(contact)
    @contact = contact
    mail(to: "josh@anyonecanlearntocode.com", subject: "New Meetup Contact - #{@contact.full_name}")
  end

  def contact_update_email(contact)
    @contact = contact
    mail(to: "josh@anyonecanlearntocode.com", subject: "Updated Meetup Contact - #{@contact.full_name}")
  end
end
