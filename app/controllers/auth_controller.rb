require 'net/imap'
require 'mail'

class AuthController < ApplicationController
  layout 'auth'
  
  # Manages the authentification process with the login page
  def login
		# If the person is already logged in, redirected to the index
    redirect_to(:controller=>"neurons", :action=>"index") unless session[:user_id].nil? 
	
		  if request.post?
			  user = User.authenticate(params[:name], params[:password])
			  if user
          session[:user_id]=user.id          
				  redirect_to(:controller=>"neurons", :action=>"index")
			  else
				  flash.now[:error] = "Wrong password"
			  end
		  end
	end

	# Manages the logout process
  def logout
    session[:user_id]=nil    
		redirect_to(:controller=>"neurons", :action=>"index")
  end
  

  def checkbrainmailbox
    #Check if token is present
    logger.info params["token"]
    if APP_CONFIG['token_action'].to_s == params["token"]
      #Start the actual work
      imap = Net::IMAP.new(APP_CONFIG['imap_host'], APP_CONFIG['imap_port'] , APP_CONFIG['imap_ssl'], nil, false)
      imap.authenticate('LOGIN', APP_CONFIG['imap_user'], APP_CONFIG['imap_password'])
      imap.select('INBOX')
      @output = "Connected to IMAP server\n"
      
      @n=0
      #Select unseen messages only
      imap.search(["NOT", "SEEN"]).each do |message_id|
    
        #Get the full content
        raw = imap.fetch(message_id, "BODY[]")[0].attr["BODY[]"]
        imap.store(message_id, '+FLAGS', [:Seen])
        #Parse it with mail library
        mail = Mail.read_from_string(raw)
        token = mail.to.to_s
        #If multipart or auth token not included, then discard the mail and send a warning
        if mail.multipart? or (not token.include?(APP_CONFIG['token_email'].to_s))
          imap.copy(message_id, 'Untreated')
          @output=@output+Time.now.getutc.to_s+" - 1 untreated mail\n"
          send_warning_mail(mail.from, raw) 
        else
          content = mail.body.decoded
          name = mail.subject
          date = mail.date
          #Detect if labels are specified in first line
          if content.lines.first.to_s[0]=="@"
            labels = content.lines.first.chomp
            content = content.lines.to_a[1..-1].join
          end
          #Here, create the neuron
          @output=@output+Time.now.getutc.to_s+" - 1 neuron created from a mail\n"
          puts "One neuron created with name '#{name}', labels '#{labels}' and content '#{content}'"
          neuron = Neuron.new
          neuron.name = name
          neuron.content = content
          neuron.labels = labels
          neuron.date = date
          neuron.save
          imap.copy(message_id, 'Treated')
        end
        imap.store(message_id, '+FLAGS', [:Deleted])
        @n+=1
      end
      imap.expunge #Delete all mails with deleted flags
      imap.close
    end
    render :layout => false
  end
  
  
  private
  
  def send_warning_mail(from, content)
    warning_mail = Mail.new do
      from    APP_CONFIG['imap_email']
      to      APP_CONFIG['warning_email']
      subject 'Non valid email received in brain mailbox'
      body    "A non valid email received in brain mailbox from "+from.to_s+"\n\n"+content.to_s
    end
    warning_mail.delivery_method :sendmail
    warning_mail.deliver
  end
  
end
