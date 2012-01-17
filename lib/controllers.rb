# -*- encoding : utf-8 -*-
class RatPack < Sinatra::Base
  before do
    #$log.debug session.inspect
    if session['user_id'].present?
      @user = User.find(session['user_id'])
      $log.debug "Session user: #{@user.inspect}"
    end
    $log.debug "Params: #{params.inspect}"
  end

  get '/' do
    haml :index
  end

  get '/users' do
    haml :'users/index', locals: { users: User.all.collect { |u| u.present(self) } }  
  end

  get '/users/new' do 
    haml :'users/new'
  end

  get '/users/:username' do 
    user = User.first(conditions: { username:params['username']})
    haml :'users/show', locals: { user: user }  
  end

  post '/users' do
    user = User.create(username: params['username']) 
    session['user_id'] = user.id.to_s
    redirect "/users/#{user.username}"
  end

  get '/logout' do
    clear_session
    $log.info "Logged out #{@user.username}. session is now: #{session.inspect}"
    redirect '/'

  end

  error do
    File.read(File.join(settings.root,'public', 'errorpage.html'))
  end
  not_found do
    File.read(File.join(settings.root,'public', 'errorpage.html'))
  end
  def clear_session
    session['session_id'] = nil
    session['user_id'] = nil
  end

end

