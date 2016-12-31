class SiteController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    @months = Month.all.reverse
    @current_month = Month.last
    @days   = Day.where(month_id: @current_month.id).order(:id)
    @week_rows = @days.last.row
  end

  def practiced
    prev_day = Day.find(params[:block_id].to_i - 1)

    streak = 1
    if prev_day.streak != nil
      streak = prev_day.streak.to_i + 1
    end

    Day.update(params[:block_id], practiced: params[:practiced], streak: streak, minutes: params[:minutes])

    # TODO: implement streak "clear"
    # TODO: implement robust streak total
    prev_day_id = prev_day.id
    while Day.find(prev_day_id).streak != nil
      Day.update(prev_day_id, streak: streak)
      prev_day_id = prev_day_id - 1
    end

    data = {:message => "POST practiced"}
    render :json => data, :status => :ok
  end

end
