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
    logger.debug "dear god: #{session[:user_id]}"
    # logger.debug "dear god 2: #{@user.id}"

    # @user = current_user
    redirect_to current_user unless current_user?(session[:user_id])
  end
end
