class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  helper_method :sort_column, :sort_direction, :inventory_last_modified

=begin
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
=end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    session[:user_id] = @user.id

    @tires = @user.tires.order(sort_column + " " + sort_direction)
    
=begin

    @diameters = Array.new
    @tires.each { |i| @diameters << i.diameter }
    @diameters.uniq!
    logger.debug @diameters

    @organized_tires = Array.new
    @diameters.each { |i| 
      
    }
=end
    
    #logger.debug "@tires: #{@tires.count}"
    #logger.debug "@tires.class: #{@tires.class}"

    if @tires.count != 0
      sql = @user.tires.order("updated_at desc").limit(1)
      @last_modified = sql[0]["updated_at"]
    end

    @title = @user.name
    @tire = @user.tires.new
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private

  def sort_column
    Tire.column_names.include?(params[:sort]) ? params[:sort] : "diameter"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
=begin
  def inventory_last_modified
    @user = User.find(params[:id])
    sql = @user.tires.order("updated_at desc").limit(1)
    @inventory_last_modified = sql[0]["updated_at"]
  end
=end
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end  
end
