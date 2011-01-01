module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  
  def current_user=(user)
    logger.debug "***** WHY?: #{@current_user}"
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end 
  
  def signed_in?
    # make this method do an authorized check as well. there is no need for a signed_in method without authorization!

    #logger.debug current_user.email
    #logger.debug session[:user_id]

    #logger.debug current_user.id
    #logger.debug params[:id]

    if !current_user.nil?
      if current_user.id.to_i == params[:id].to_i
        return true
      end
    end
    #!current_user.nil?

    # also add user == current_user check?  avoid duplication!

    #if session[:user_id].nil?
    #  session[:user_id] = 1
    #end

    # @user = User.find(session[:user_id])
    #current_user?(@user)

    # could put the redirect to root_path here and abstract all the model before_filter crap.
  end
  
  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
  end
  
  private
  
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
  
  def current_user?(last_user_viewed)
    # logger.debug "#{last_user_viewed} VS #{current_user}"
    # logger.debug @current_user == current_user
    # logger.debug current_user 
    # logger.debug user
    last_user_viewed == current_user.id
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    logger.debug "#{default.inspect} - #{session[:return_to]}"
    redirect_to(session[:return_to] || default)
    #redirect_to default if session[:return_to].nil? 
    clear_return_to
  end
  
  def clear_return_to
    session[:return_to] = nil
  end
end
