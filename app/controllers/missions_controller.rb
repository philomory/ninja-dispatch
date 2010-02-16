class MissionsController < ApplicationController
  before_filter :check_logged_in, :except => [:show,:index]
  before_filter :find_ninja, :only => [:new, :create]
  before_filter :correct_user?, :only => [:new, :create]
  before_filter :ninja_available?, :only => [:new, :create]
  

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
    @mission = @ninja.missions.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mission }
    end
  end

  # POST /missions
  # POST /missions.xml
  def create
    @mission = @ninja.missions.create(params[:mission])

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
  def find_ninja
    @ninja = Ninja.find(params[:ninja_id])
  end

  def correct_user?
    unless @ninja.user == current_user
      flash[:notice] = "You can only send your own Ninjas on missions. Is that what you meant to do?"
      redirect_to user_url(current_user)
    end
  end

  def ninja_available?
    unless @ninja.available?
      flash[:notice] = "This ninja is already on a mission, and cannot be sent on a new one until " +
                       "their current mission is completed."
      redirect_to user_url(current_user)
    end
  end

end
