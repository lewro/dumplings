class UserMailer < ActionMailer::Base

  #Send PDF Document
  def email_pdf(email, subject, body, from, file_name, file)
    @email    = email
    @subject  = subject
    @body     = body
    @from     = from

    attachments[file_name] = File.read(file)

    mail(
      :to => @email,
      :subject => @subject,
      :from => @from,
      :body => @body,
      reply_to: @from
      ) do |format|
        format.html { render "email_pdf" }
    end
  end
end
