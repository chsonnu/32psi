class TiresController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :update]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @tire = current_user.tires.build(params[:tire])

    if @tire.save
      flash[:success] = "Tire added!"
      redirect_to current_user
    else
      @user = current_user
      @tires = current_user.tires
      # flash[:error] = "Tire wasn't created!"
      # redirect_to current_user
      render 'users/show'
    end
  end

  def destroy
    @tire.destroy
    redirect_back_or root_path
  end

  def update
    @tire = current_user.tires.find(params[:id])
    @op = %w[inc dec].include?(params[:op]) ? params[:op] : nil
    @num = @op == 'inc' ? +1 : -1

    if @tire.update_attribute(:quantity, @tire.quantity += @num.to_i)
      respond_to do |format|
        format.html { redirect_to current_user}
        format.js
      end
    else     
      redirect_to current_user
    end

  end
  
  private

  def authorized_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless current_user?(@micropost.user)
  end
end
