class SiteController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!, only: [:practiced]

  def index
    @months = Month.all.reverse
    @current_month = Month.last
    @days   = Day.where(month_id: @current_month.id).order(:id)
    @week_rows = @days.last.row
  end

  def practiced
    saturation = [ "#ffe6e6", "#ffcccc", "#ffb3b3", "#ff9999", "#ff8080", "#ff6666", "#ff4d4d", "#ff3333", "#ff1a1a", "#ff0000" ]
    color = ""

    prev_day = Day.find(params[:block_id].to_i - 1)

    streak = 1
    if prev_day
      if prev_day.streak != nil
        streak = prev_day.streak.to_i + 1
        if streak >= 9
          streak = 9
        end
        color = saturation[streak]
      end
    end

    Day.update(params[:block_id], practiced: params[:practiced], streak: streak, minutes: params[:minutes], color: color)

    # TODO: implement streak "clear"
    # TODO: implement robust streak total
    if prev_day
      prev_day_id = prev_day.id
      while Day.find(prev_day_id).streak != nil
        Day.update(prev_day_id, streak: streak, color: color)
        prev_day_id = prev_day_id - 1
      end
    end

    # data = {:message => "POST practiced"}
    # render :json => data, :status => :ok

    # redirect_to root_path
    # render :js => "window.location = #{root}"
    render :js => "window.location = '/'"
  end

end
