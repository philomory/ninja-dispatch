class NinjasController < ApplicationController
  before_filter :check_logged_in, :except => [:show, :ancestors]
  before_filter :check_room_for_more, :only => [:new, :create]
  before_filter :find_user, :only => [:new, :create]
  before_filter :correct_user?, :only => [:new, :create]
  before_filter :find_ninja, :only => [:show,:retire]
  
  def show
  end

  def retire
    if @ninja.user == current_user
      @ninja.retire!
    else
      flash[:notice] = "You can't retire someone else's ninja!"
    end
    redirect_to ninja_url(@ninja)
  end

  def new
    @ninja = @user.active_ninjas.build
  end
  
  def create
    @ninja = @user.active_ninjas.build(params[:ninja])
    if @ninja.save
      redirect_to ninja_url(@ninja)
    else
      render :action => 'new'
    end
  end
  
  private
  def check_room_for_more
    unless current_user.room_for_more?
      flash[:notice] = "You can only have three ninjas active at a time. " +
                       "If you want to hire a new ninja, you'll have to retire " +
                       "one of your current ninjas first."
      redirect_to user_url(current_user)
    end
  end
  
  def find_ninja
    @ninja = Ninja.find(params[:id])
  end
  
  def find_user
    @user = User.find_by_login(params[:user_id])
  end
  
  def correct_user?
    unless @user == current_user
      flash[:notice] = "You can only train Ninjas for your own dojo. Is that what you meant to do?"
      redirect_to new_user_ninja_url(current_user)
    end
  end
  
end
