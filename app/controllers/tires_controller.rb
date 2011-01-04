class TiresController < ApplicationController
  # before_filter :authenticate, :only => [:create, :destroy, :update]
  before_filter :authorized_user, :only => [:create, :destroy, :update]

  def create
    @tire = current_user.tires.build(params[:tire])

    tire_count = Tire.count(:conditions => "width = #{@tire.width} AND sidewall = #{@tire.sidewall} AND diameter = #{@tire.diameter} AND condition = #{@tire.condition} AND user_id = #{current_user.id}")

    if tire_count == 0
      @tire.save
      flash[:success] = "The tire has been added."
      redirect_to current_user
    else
      @user = current_user
      @tires = current_user.tires
      flash[:alert] = "The tire record for #{@tire.width} / #{@tire.sidewall} / #{@tire.diameter} at #{@tire.condition}% already exists.  Try incrementing the quantity of the existing tire record instead."

      redirect_to current_user
      # render 'users/show'
    end
  end

  def update
    @tire = current_user.tires.find(params[:id])
    @op = %w[inc dec].include?(params[:op]) ? params[:op] : nil
    @num = @op == 'inc' ? +1 : -1

    if @tire.update_attribute(:quantity, @tire.quantity += @num.to_i)
      sql = current_user.tires.order("updated_at desc").limit(1)
      @inventory_last_modified = sql[0]["updated_at"]

      respond_to do |format|
        format.html { redirect_to current_user}
        format.js
      end
    else     
      redirect_to current_user
    end
  end
  
  def destroy
    @tire.destroy
    redirect_back_or root_path
  end

  private

  def authorized_user
    # what you could do is pass the user id along with the tire id and inc/dec in the update link.
    # that would solve your fucking problem and you wouldn't have to use sessions.

    # could have an hidden value in the tire form for the user.id?  
    # ultimately used a session in UserController#show.
    # session[:user_id] = 2

    # @user = User.find(params[:id])

    logger.debug "dear god: #{session[:user_id]}"
    # logger.debug "dear god: #{@user.id}"

    # @user = current_user
    redirect_to root_path unless current_user?(session[:user_id])
  end
end
