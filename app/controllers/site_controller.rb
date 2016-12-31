class SiteController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    @months = Month.all.reverse
    @current_month = Month.last
    @days   = Day.where(month_id: @current_month.id).order(:id)
  end

  def practiced
    last_day = Day.find(params[:block_id].to_i - 1)

    streak = 1
    if last_day.streak != nil
      streak = last_day.streak.to_i + 1
    end

    # increment up and down, reset values to nil, until you get a nil in either direction
    # increment both directions and all the streak #s should be the same!!!!
    # this number will be consistent within a steak and help set the color

    Day.update(params[:block_id], practiced: params[:practiced], streak: streak, minutes: params[:minutes])

    data = {:message => "POST practiced"}
    render :json => data, :status => :ok
  end

end
