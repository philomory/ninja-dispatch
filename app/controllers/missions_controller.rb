class MissionsController < ApplicationController
  # GET /missions
  # GET /missions.xml
  def index
    @missions = Mission.all

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
    @mission = Mission.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mission }
    end
  end

  # POST /missions
  # POST /missions.xml
  def create
    @mission = Mission.new(params[:mission])

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



end
