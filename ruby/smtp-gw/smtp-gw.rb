#!/usr/bin/ruby

require 'bundler/setup'
Bundler.require

class SmtpGwServer < MiniSmtpServer
  def setSmtpServer(address,port,domain)
    @smtp_address = address
    @smtp_port    = port
    @smtp_domain  = domain
  end

  def new_message_event(message_hash)
    puts "="*80
    puts "mail recieved.time=" + Time.now.strftime("%Y-%m-%d %H:%M:%S")
    puts "-"*60
    puts message_hash

    mail = nil
    Tempfile.open("mail-") do |f|
      f.puts message_hash[:data]
      f.close
      mail = Mail.read(f.path)
      f.close(true)
    end

    # memo:Pony.mailで以下のエラー発生
    # 501:domain指定無しの時
    # 553:from指定なしの時
    sendmail = {
      :from           => mail.from,
      :to             => mail.to,
      :cc             => mail.cc,
      :bcc            => mail.bcc,
      :subject        => mail.subject,
      :via            => :smtp,
      :via_options => {
        :address        => @smtp_address,
        :port           => @smtp_port,
        :authentication => :plain,
        :domain         => @smtp_domain,
      }
    }

    bodypart = nil
    if mail.multipart? then
      sendmail[:attachments] = mail.attachments.map{|a| {a.filename => a.decoded}}.inject(:merge)
      mail.parts.each{|p| p p.content_type}
      bodypart = mail.parts.find{|p| p.content_type["text/"]}
    else
      bodypart = mail
    end

    charset = bodypart.content_type_parameters["charset"]
    body    = bodypart.body.decoded
    body.force_encoding(charset)
    sendmail[:body] = body.encode('utf-8')

    puts "-"*60
    p sendmail

    Pony.mail(sendmail)
    puts "-"*60
    puts "mail forwarded.time=" + Time.now.strftime("%Y-%m-%d %H:%M:%S")
  rescue => e
    puts "-"*60
    puts "ERROR!!!!"
    p e
    puts e.backtrace.join("\n")
  end

end

  


# Daemons
#  プロセスをdaemonとして起動する
#  稼働ディレクトリに、aap.pidというファイルができて、それで稼働中プロセスのpidを管理
#  スクリプトのオプションとしてコマンド付与する事で、プロセスの稼働制御が可能
#  <コマンド>
#   xxx.rb status : 稼働statusを表示
#   xxx.rb start  : プロセスをdaemon起動
#   xxx.rb stop   : 稼働中プロセスを停止
daemon_options = {
  :backtrace          => true,  # exception     => app.log
  :log_output         => true   # stdout,stderr => app.output
}

Daemons.run_proc('smtp-gw',daemon_options) do
  # -b : bind_address:port
  # -s : smtp-server:port
  
  bind_address = ""
  bind_port    = 0
  smtp_address = ""
  smtp_port    = 0
  smtp_domain  = ""
  ARGV.each{|p|
    case p
    when /^-p:([0-9.]+)(:([0-9]+)|)$/
      bind_address = $1
      bind_port    = $2.to_i
    when /^-s:(([A-Za-z0-9-]+)\.([A-Aa-z0-9.-]+))(:([0-9]+)|)$/
      smtp_address = $1
      smtp_domain  = $3
      smtp_port    = $5.to_i
    end
  }

  if bind_address.length == 0 then
    bind_address = "127.0.0.1"
  end
  if(bind_port <= 0)then
    bind_port  = 2525
  end
  if (smtp_address.length == 0) or (smtp_domain.length ==0) then
    print "smtp param nothing!!!!\n"
    print "set stmp parameter '-s:smtp-server:port'\n"
    print "exit program\n"
    exit
  end
  if(smtp_port <= 0)then
    smtp_port  = 25
  end
  print "bind=#{bind_address}:#{bind_port}\n"
  print "smtp=#{smtp_address}:#{smtp_port}(domain=#{smtp_domain})\n"

  server = SmtpGwServer.new(bind_port,bind_address, 4)
  server.setSmtpServer(smtp_address,smtp_port,smtp_domain)
  server.start
  server.join
end

