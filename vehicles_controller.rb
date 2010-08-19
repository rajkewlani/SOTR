class VehiclesController < ApplicationController
  before_filter :login_required
  layout 'admin'
  def index
    @vehicles = Vehicle.paginate(:all, :page => params[:page], :per_page => 10)
  end

  def new
    @vehicle = Vehicle.new()
  end

  def create
    @vehicle = Vehicle.create!(params[:vehicle])
    redirect_to :action => "index"
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    @vehicle.update_attributes(params[:vehicle])
    redirect_to :action => "index"
  end
  
  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy
    redirect_to :action => "index"
  end

  def vehicle_schedule
    @selectedDate = session[:selectedDate].to_s(:db)
    @vehicle_usage = VehicleUsage.find(:all, :conditions => ["date = ?", @selectedDate], :select => 'vehicle_id')
    if @vehicle_usage.count > 0
      @vehicle_id = Array.new
      @vehicle_usage.each do |id|
        @vehicle_id << id.vehicle_id
      end
    end
    @vehicles = Vehicle.paginate(:all, :page => params[:page], :per_page => 10)
  end

  def schedule_date
    strdate = params[:date].to_date.strftime('%Y/%m/%d')
    session[:selectedDate] = strdate.to_date
    render :update do |page|
      page.redirect_to(:action => "vehicle_schedule")
    end
  end

  def vehicle_schedule_add
    VehicleUsage.create!(:vehicle_id => params[:vehicle_id] ,:date => session[:selectedDate].to_s(:db))
    redirect_to :action => "vehicle_schedule"
  end

  def vehicle_schedule_remove
    @vehicle_usage = VehicleUsage.find_by_vehicle_id_and_date(params[:vehicle_id],session[:selectedDate])
    @vehicle_usage.destroy
    redirect_to :action => "vehicle_schedule"
  end

  def vehicle_blackout
    @vehicle_blackout = VehicleBlackout.paginate(:all, :order => "created_at DESC", :page => params[:page], :per_page => 10)
  end

  def new_vehicle_blackout
    @vehicle = Vehicle.find(:all)
  end

  def create_vehicle_blackout
    @blackout = VehicleBlackout.new()
    @blackout.vehicle_id = params[:vehicle_blackout][:vehicle_id]
    @blackout.description = params[:vehicle_blackout][:description]
    @blackout.start_date = params[:datepicker_start_date]
    @blackout.start_time = params[:from][:"time(5i)"]
    @blackout.end_date = params[:datepicker_end_date]
    @blackout.end_time = params[:to1][:"time(5i)"]
    @blackout.save
    @vehicle_blackout = VehicleBlackout.paginate(:all, :order => "created_at DESC", :page => params[:page], :per_page => 10)
    redirect_to :action => "vehicle_blackout"
  end

  def edit_vehicle_blackout
    @vehicle = Vehicle.find(:all)
    @vehicle_blackout = VehicleBlackout.find_by_vehicle_blackout_id(params[:vehicle_id])
  end

  def set_vehicle_blackout
    @blackout = VehicleBlackout.find_by_vehicle_blackout_id(params[:vehicle_id])
    @blackout.vehicle_id = params[:vehicle_blackout][:vehicle_id]
    @blackout.description = params[:vehicle_blackout][:description]
    @blackout.start_date = params[:datepicker_start_date]
    @blackout.start_time = params[:from][:"time(5i)"]
    @blackout.end_date = params[:datepicker_end_date]
    @blackout.end_time = params[:to1][:"time(5i)"]
    @blackout.save
    @vehicle_blackout = VehicleBlackout.paginate(:all, :order => "created_at DESC", :page => params[:page], :per_page => 10)
    redirect_to :action => "vehicle_blackout"
  end

  def delete_vehicle_blackout
    @vehicle_blackout = VehicleBlackout.find_by_vehicle_blackout_id(params[:vehicle_id])
    @vehicle_blackout.destroy
    @vehicle_blackout = VehicleBlackout.paginate(:all, :order => "created_at DESC", :page => params[:page], :per_page => 10)
    redirect_to :action => "vehicle_blackout"
  end
end