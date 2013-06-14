class ServiceRequestMailer < ActionMailer::Base
  default from: "gmonne@rivani.com.uy"

  def send_email(to, opts={})
    opts[:server] 		||= 'mail.rivani.com.uy'
    opts[:from]			||= 'gmonne@rivani.com.uy'
    opts[:from_alias]	||= 'Guzman Monne'
    opts[:subject]		||= 'RBKApps'
    opts[:body]			||= 'Mail de Prueba'

    msg = <<END_OF_MSG
From: #{opts[:from_alias]}<#{opts[:from]}>
To: <#{to}>
MIME-Version: 1.0
Content-type: text/html
Subject: #{opts[:subject]}

    #{opts[:body]}
END_OF_MSG

    Net::SMTP.start(opts[:server], 587, 'rivani.com.uy', 'gmonne@rivani.com.uy', 'Guxmaster*6151', :login) do |smtp|
      smtp.send_message msg, opts[:from], to
    end
  end

  def service_request_created_email(user, service_request)
    msg = <<EOF
<html>
  <head>
    <title>Example</title>
  </head>
  <body style="margin: 0;font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;font-size: 14px;line-height: 20px;color: #333;background-color: #fff">
<table class="table table striped" style="max-width: 100%;background-color: transparent;border-collapse: collapse;border-spacing: 0;width: 100%;margin-bottom: 20px"><thead><tr><td colspan="2" style="padding: 8px;line-height: 20px;text-align: left;vertical-align: top;border-top: 0">
        <h1 style="margin: 10px 0;font-family: inherit;font-weight: bold;line-height: 40px;color: inherit;text-rendering: optimizelegibility;font-size: 38.5px">Ha creado con exito la solicitud #{user.id}</h1>
      </td>
    </tr><tr><td colspan="2" style="padding: 8px;line-height: 20px;text-align: left;vertical-align: top;border-top: 1px solid #ddd">
        <h2 style="margin: 10px 0;font-family: inherit;font-weight: bold;line-height: 40px;color: inherit;text-rendering: optimizelegibility;font-size: 31.5px">Datos de Solicitud</h2>
      </td>
    </tr></thead><tbody><tr><td style="padding: 8px;line-height: 20px;text-align: left;vertical-align: top;border-top: 1px solid #ddd">ID</td>
      <td style="padding: 8px;line-height: 20px;text-align: left;vertical-align: top;border-top: 1px solid #ddd">#{service_request.id}</td>
    </tr><tr><td style="padding: 8px;line-height: 20px;text-align: left;vertical-align: top;border-top: 1px solid #ddd">Titulo</td>
      <td style="padding: 8px;line-height: 20px;text-align: left;vertical-align: top;border-top: 1px solid #ddd">#{service_request.title}</td>
    </tr></tbody></table></body>
</html>

EOF
    send_email('gmonne@rivani.com.uy', :body => msg)
  end

  def header
    header = <<EOF
<img src="http://127.0.0.1:3001/assets/logo.png" style="margin: 16px;padding: 20px; background-color: #F5F5F5"/>
EOF
  end

  def h1_style
    h1_style = <<EOF
  margin: 10px 0;
  font-family: inherit;
  font-weight: bold;
  line-height: 20px;
  color: inherit;
  text-rendering: optimizelegibility;
EOF
  end

  def well
    well = <<EOF
  min-height: 20px;
  padding: 19px;
  margin-bottom: 20px;
  background-color: #f5f5f5;
  border: 1px solid #e3e3e3;
  -webkit-border-radius: 4px;
     -moz-border-radius: 4px;
          border-radius: 4px;
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
     -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
          box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
EOF
  end

  def table
    table = <<EOF
max-width: 100%;
background-color: transparent;
border-collapse: collapse;
border-spacing: 0;
width: 100%;
margin-bottom: 20px;
font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
font-size: 14px;
line-height: 20px;
color: #333333;
EOF
  end

  def striped
    table_striped = <<EOF
   background-color: #f9f9f9;
EOF
  end
end

