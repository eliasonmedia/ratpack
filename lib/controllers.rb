# -*- encoding : utf-8 -*-
class RatPack < Sinatra::Base
  before do
    $log.debug session.inspect
    if session['user_id'].present?
      begin
        @user = User.find(session['user_id']) unless session['user_id'].nil?
      rescue Mongoid::Errors::DocumentNotFound => e
        clear_session
      end
      $log.debug("user- #{@user.inspect}")
    end
  end


  get '/' do
    if @user.nil?
      haml :index, :layout => :landing_layout
    else
      haml :user_page, locals: { user: @user.present(self) }
    end
  end
  error do
    $log.error "session: #{session.inspect}"
    $log.error "user :#{@user.inspect}" 
    File.read(File.join(settings.root,'public', 'errorpage.html'))
  end
  not_found do
    File.read(File.join(settings.root,'public', 'errorpage.html'))
  end
  def clear_session
    session['user_id'] = nil
    session['session_id'] = nil
  end

  get '/auth/:name/callback' do
    begin
      $log.info "omniauth callback: #{request.env['omniauth.auth'].inspect}"
      if (@user = User.where(:facebook_id =>  request.env['omniauth.auth']['uid'].to_i ).first)
        @user.auth_token =  request.env['omniauth.auth']['credentials']['token']
        $log.info "Already found user: #{@user.inspect}" 
      else
        @user =  User.new(
          :first_name => request.env['omniauth.auth']['user_info']['first_name'],
          :last_name => request.env['omniauth.auth']['user_info']['last_name'],
          :facebook_id => request.env['omniauth.auth']['uid'].to_i, 
          :auth_token => request.env['omniauth.auth']['credentials']['token'], 
          :username => username, 
          :email => request.env['omniauth.auth']['user_info']['email']
        )
        $log.debug "New user: #{@user.inspect}"
      end

      if @user.save
        $log.info "User #{@user.id.to_s} saved!" 
        session['user_id'] = @user.id.to_s
      else
        $log.error "#{@user.id.to_s} failed to save #{@user.errors.inspect}" 
      end
    rescue Exception => e 
      $log.error e.inspect
      $log.error e.backtrace.join("\n\t")
      clear_session
    ensure
      redirect '/'
    end
  end
  get '/auth/failure' do
    clear_session
    redirect_to '/'
  end

  get '/logout' do
    clear_session
    $log.info "Logged out #{@user.username}. session is now: #{session.inspect}"
    redirect '/'
  end
  ### admin
  get '/admin/users/all' do
    @users = User.all
    haml :'admin/all_users'
  end
end
