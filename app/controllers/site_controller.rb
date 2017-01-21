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
    # blue
    saturation = [ "", "#e6e6ff", "#ccccff", "#b3b3ff", "#9999ff", "#8080ff", "#6666ff", "#4d4dff", "#3333ff", "#1a1aff", "#0000ff", "#0000e6" ]

    # yel-org-red hash
    # "#0066cc" rgba(0, 102, 204)
    # saturation = [ "", {"yellow" => 0.2}, {"yellow" => 0.4}, {"yellow" => 0.6}, {"yellow" => 0.8}, {"yellow" => 0.9},
                       # {"orange" => 0.2}, {"orange" => 0.4}, {"orange" => 0.6}, {"orange" => 0.8}, {"orange" => 0.9},
                       # {"red" => 0.2}, {"red" => 0.4}, {"red" => 0.6}, {"red" => 0.8}, {"red" => 0.9} ]

    if params[:practiced] == "1"
      # blue
      color = saturation[1]

      # yel-org-red hash
      # color = (saturation[1].keys)[0].to_s
      # transparency = saturation[1][color]

      prev_day = Day.find(params[:day_id].to_i - 1)

      streak = 1
      if prev_day.streak != nil
        streak = prev_day.streak.to_i + 1

        # blue
        if streak >= 11
          streak = 11
        end
        color = saturation[streak]
        transparency = 0.9

        # yel-org-red hash
        # if streak >= 15
          # streak = 15
        # end
        # color = (saturation[streak].keys)[0].to_s
        # transparency = saturation[streak][color]
      end

      Day.update(params[:day_id], practiced: params[:practiced], streak: streak, minutes: params[:minutes], color: color, transparency: transparency)
    else
      # if practice time is deleted, streak can be broken... forward only!
      # iterate fwd until streak = nil
      # need to figure out how to recalculate streak after the break

      Day.update(params[:day_id], practiced: params[:practiced], streak: nil, minutes: nil, color: nil, transparency: nil)
    end

    data = {:message => "POST practiced", :color => color}
    render :json => data, :status => :ok
  end

end
