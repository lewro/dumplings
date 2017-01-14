class UserMailer < ActionMailer::Base

  #Send PDF Document 
  def pdf_email(email, subject, body, from, file_name, file)
    @email    = email
    @subject  = subject
    @body     = body
    @from     = from

    attachments[file_name] = file

    mail(
      :to => @email,
      :subject => @subject,
      :from => @from,
      :body => @body,
      reply_to: @from
      ) do |format|
        format.html { render "invoice_email" }
    end
  end
