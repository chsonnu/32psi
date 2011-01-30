class TiresController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :update]
  # before_filter :authorized_user, :only => [:create, :destroy, :update]
  before_filter :authorized_user, :only => [:destroy]

  def create
    @tire = current_user.tires.build(params[:tire])

    @tire_spec =  "#{@tire.width} / #{@tire.sidewall} / #{@tire.diameter} / #{@tire.condition} % / $ #{@tire.price}"

    # tire_count = Tire.count(:conditions => "width = #{@tire.width} AND sidewall = #{@tire.sidewall} AND diameter = #{@tire.diameter} AND condition = #{@tire.condition} AND user_id = #{current_user.id}")
    tire_count = 0

    if tire_count == 0
      @tire.save
      flash[:success] = "Tire record #{@tire_spec} has been added."
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
        format.html { redirect_to current_user }
        format.js
      end
    else     
      redirect_to current_user
    end
  end
  
  def destroy
    @tire = current_user.tires.find(params[:id])

    text = "#{@tire.width} / #{@tire.sidewall} / #{@tire.diameter}"

    @tire.destroy
    # User.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to current_user }
      format.js
    end

    # flash[:success] = "Record \"#{text}\" was deleted."
    # redirect_to current_user
  end

  private

  def authorized_user
    logger.debug "tires_controller#authorized_user"

    @tire = Tire.find(params[:id])

    logger.debug @tire.user

    redirect_to root_path unless current_user?(@tire.user)
  end
end
