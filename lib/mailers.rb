# -*- encoding : utf-8 -*-
class Mailer 
  def self.deliver_sign_up_email(user_id)
    userobj = User.find(user_id)
    userobj.update_attributes(last_email_sent: Date.today)
    user = userobj.present(self)

    html_template = File.read(File.join(RatPack.root, 'views', 'emails', 'welcome.haml'))
    text_template = File.read(File.join(RatPack.root, 'views', 'emails', 'welcome.text.erb'))
    Pony.mail( 
              to: user.email, 
              from: RatPack.email_from_address,
              subject: "Welcome to the RatPack!", 
              body: Erubis::Eruby.new(text_template).result(user: user), 
              html_body: Haml::Engine.new(html_template).render(self, user: user)
             )
  end
end
