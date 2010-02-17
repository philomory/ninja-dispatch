class MissionsController < ApplicationController
  before_filter :check_logged_in, :except => [:show,:index]
  
  layout 'application.html.erb'

  # GET /missions
  # GET /missions.xml
  def index
    @missions = Mission.all :conditions => {:state => [:succeeded, :failed]}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @missions }
    end
  end

  # GET /missions/1
  # GET /missions/1.xml
  def show
    @mission = Mission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mission }
    end
  end

  # GET /missions/new
  # GET /missions/new.xml
  def new
    if params[:ninja_id]
      ninja = Ninja.find(params[:ninja_id])
      return unless correct_user?(ninja.user); return unless ninja_available?(ninja)
      @mission = ninja.missions.build
    else
      return unless any_ninja_available?
      @mission = Mission.new
    end
      
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mission }
    end
  end

  # POST /missions
  # POST /missions.xml
  def create
    ninja = Ninja.find(params[:mission][:ninja_id])
    return unless correct_user?(ninja.user); return unless ninja_available?(ninja)
    return unless victim_different_from_master?

    @mission = Mission.create(params[:mission])

    respond_to do |format|
      if @mission.save
        flash[:notice] = 'Mission was successfully created.'
        format.html { redirect_to(@mission) }
        format.xml  { render :xml => @mission, :status => :created, :location => @mission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mission.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def correct_user?(user)
    correct = (user == current_user)
    unless correct
      flash[:notice] = "You can only send your own Ninjas on missions. Is that what you meant to do?"
      redirect_to user_url(current_user)
    end
    return correct
  end

  def ninja_available?(ninja)
    unless ninja.available?
      flash[:notice] = "This ninja is already on a mission, and cannot be sent on a new one until " +
                       "their current mission is completed."
      redirect_to user_url(current_user)
    end
    return ninja.available?
  end
  
  def any_ninja_available?(user = current_user)
    any_available = user.active_ninjas.any? {|ninja| ninja.available?}
    unless any_available
      flash[:notice] = "All of your ninjas are currently already on missions. "
      if user.room_for_more?
        flash[:notice] += "You can create a new ninja, and send him on a mission, though."
        redirect_to new_user_ninja_url(current_user)
      else
        flash[:notice] += "You already have #{User::MAX_ACTIVE_NINJAS} ninjas " +
                          "active, so you'll have to wait for one to finish before " +
                          "beginning any new missions."
        redirect_to user_url(current_user)
      end
    end
    return any_available
  end

  def victim_different_from_master?
    victim_id = params[:mission][:victim_id]
    master_id = Ninja.find(params[:mission][:ninja_id]).user_id
    different = (victim_id != master_id)
    unless different
      flash[:notice] = "You can't send one of your ninjas on a mission with " +
                       "yourself as the victim!"
      redirect_to new_mission_url
    end
    return different
  end
    

end
