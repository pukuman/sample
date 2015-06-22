#!/usr/bin/ruby

require 'bundler/setup'
Bundler.require

class SmtpProxyServer < MiniSmtpServer
  def setSmtpServer(address,port)
    @smtp_address = address
    @smtp_port    = port
  end

  def new_message_event(message_hash)
    puts "="*80
    puts "mail recieved.time=" + Time.now.strftime("%Y-%m-%d %H:%M:%S")

    mail = nil
    Tempfile.open("mail-") do |f|
      f.puts message_hash[:data]
      f.close
      mail = Mail.read(f.path)
      f.close(true)
    end
    
    mail_from    = mail.from
    mail_to      = mail.to

    mail_encoded = message_hash[:data]

    puts "-----"
    puts message_hash
    puts "-----"
    puts "mail from:#{mail_from}"
    puts "mail to:#{mail_to}"
    puts "-----"
    puts mail_encoded
#    puts mail_encoded.match( %r"^from:.*$" )
#    puts mail_encoded.match( %r"^to:.*$" )
#    puts mail_encoded.match( %r"^Subject:.*$" )

#    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
#    puts :tls_enabled

    Net::SMTP.start( @smtp_address, @smtp_port ){|smtp|
      print "sendmail(",@smtp_address,":",@smtp_port,")\n"
      begin
        smtp.sendmail( mail_encoded, mail_from, mail_to )
      rescue => exept
        puts "sendmail error." +  exept
      end
    }
    puts "mail forwarded.time=" + Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

end

bind_address = "10.0.2.15"
bind_port    = 2525
smtp_address = "172.19.30.81"
smtp_port    = 25


server = SmtpProxyServer.new(bind_port,bind_address, 4)
server.setSmtpServer(smtp_address,smtp_port)
server.start
server.join
