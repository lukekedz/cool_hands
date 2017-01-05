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
    saturation = [ "", "#e6e6ff", "#ccccff", "#b3b3ff", "#9999ff", "#8080ff", "#6666ff", "#4d4dff", "#3333ff", "#1a1aff", "#0000ff", "#0000e6" ]
    color = saturation[1]

    prev_day = Day.find(params[:block_id].to_i - 1)

    streak = 1
    if prev_day.streak != nil
      streak = prev_day.streak.to_i + 1
      if streak >= 11
        streak = 11
      end
      color = saturation[streak]
    end

    Day.update(params[:block_id], practiced: params[:practiced], streak: streak, minutes: params[:minutes], color: color)

    # TODO: implement streak "clear"
    # TODO: implement robust streak total
    # if prev_day
    #   prev_day_id = prev_day.id
    #   while Day.find(prev_day_id).streak != nil
    #     Day.update(prev_day_id, streak: streak, color: color)
    #     prev_day_id = prev_day_id - 1
    #   end
    # end

    # data = {:message => "POST practiced"}
    # render :json => data, :status => :ok

    # redirect_to root_path
    # render :js => "window.location = #{root}"
    render :js => "window.location = '/'"
  end

end
