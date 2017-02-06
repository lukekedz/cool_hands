class SiteController < ApplicationController
  # protect_from_forgery with: :exception
  before_action :authenticate_user!, only: [:practiced]

  def index
    if first_of_the_month?
      time = Time.new
      month_length = Date.new(Time.new.year, Time.new.month, -1).day

      new_yr = time.year.to_s
      new_mm = time.month.to_s.length < 2 ? "0" + time.month.to_s : time.month.to_s
      yyyymm = new_yr + new_mm

      Month.create(name: time.strftime("%B"), length: month_length, yyyymm: yyyymm)

      populate_new_month(month_length)
    end

    @current_month = params[:id] ? Month.find(params[:id]) : Month.last

    @days      = Day.where(month_id: @current_month.id).order(:id)
    @months    = Month.all.reverse
    @week_rows = @days.last.row
    @mms       = monthly_minutes(@current_month.id)
    @hrs       = total_hrs_practiced()
  end

  def monthly_minutes(month_id)
    mms = 0

    Day.where(month_id: month_id).each do |d|
      if d.minutes
        mms = mms + d.minutes
      end
    end

    mms
  end

  def total_hrs_practiced
    mins = 0

    Day.all.each do |d|
      if d.minutes
        mins = mins + d.minutes
      end
    end

    mins / 60
  end

  def first_of_the_month?
    db = Month.last.yyyymm
    db_year = db[0..3]
    db_mnth = db[4..5]

    time = Time.new
    curr_year = time.year.to_s
    curr_mnth = time.month.to_s.length < 2 ? "0" + time.month.to_s : time.month.to_s

    if db_year != curr_year
      # not a match
      # the calendar has gone from 1231 to 0101, a new year!
      return true
    else
      if db_mnth != curr_mnth
        # month has progressed 30,31 to 01
        return true
      else
        # year and month match!
        # you are in current month
        return false
      end
    end
  end

  def populate_new_month(month_length)
    row = 0
    # numbered day of week, ie Sun 0, Mon 1
    # TODO: verify correct month creation on March 1st!
    block = Date.new(Time.new.year, Time.new.month, 1).strftime("%w").to_i
    date_day = 1

    42.times do |i|

      if i >= block && date_day <= month_length
        Day.create(
          month_id:   Month.last.id,
          row:        row,
          block:      block,
          clickable:  true,
          practiced:  0,
          date:       Date.new(Time.new.year, Time.new.month, date_day),
          color:      "transparent",
          text_color: "black"
        )

        date_day += 1

        if block < 6
          block += 1
        else
          block = 0
          row += 1
        end
      else
        Day.create(
          month_id:  Month.last.id,
          row:       row,
          block:     (date_day > month_length ? block : i),
          clickable: false,
          practiced: 0,
        )

        if date_day > month_length
          if block < 6
            block += 1
          else
            block = 0
            row += 1
          end
        end

      end
    end
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

      # picks up streak where last left,
      # ie it will ignore empty blocks from a new month start / old month finish
      prev_day = []
      i = 1
      until prev_day.empty? != true
        prev_day = Day.where(id: params[:day_id].to_i - i, clickable: true)
        i += 1
      end

      streak = 1
      if prev_day[0].streak != nil
        streak = prev_day[0].streak.to_i + 1

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

      Day.update(params[:day_id],
                  practiced:    params[:practiced],
                  streak:       streak,
                  minutes:      params[:minutes],
                  color:        color,
                  transparency: transparency
                )
    else
      # TODO: recalculate streak if somehow broken
      Day.update(params[:day_id],
                  practiced:    params[:practiced],
                  streak:       nil,
                  minutes:      nil,
                  color:        "transparent",
                  transparency: nil
                )
    end

    data = {:message => "POST practiced", :color => color}
    render :json => data, :status => :ok
  end

  def iot
    # TODO: error handling, notification, edge cases
    day = Day.where(date: Time.now.to_s[0..9])

    saturation = [ "", "#e6e6ff", "#ccccff", "#b3b3ff", "#9999ff", "#8080ff", "#6666ff", "#4d4dff", "#3333ff", "#1a1aff", "#0000ff", "#0000e6" ]
    color = saturation[1]

    prev_day = []
    i = 1
    until prev_day.empty? != true
      prev_day = Day.where(id: day[0].id.to_i - i, clickable: true)
      i += 1
    end

    streak = 1
    if prev_day[0].streak != nil
      streak = prev_day[0].streak.to_i + 1

      # blue
      if streak >= 11
        streak = 11
      end

      color = saturation[streak]
      transparency = 0.9
    end

    puts "TIME NOW: " + Time.now.to_s[0..9].inspect
    puts "TIME DAY: " + day[0].date.inspect
    puts "MINUTES: " + day[0].minutes.inspect

    if day[0].minutes == nil
      Day.update(day[0].id, minutes: 0)
    else
      practiced = ((Time.now - day[0].updated_at) / 60).round

      # TODO: need color code, saturation, etc.
      Day.update(day[0].id,
                  minutes:      practiced,
                  practiced:    1,
                  streak:       streak,
                  color:        color,
                  transparency: transparency
                )
    end

    redirect_to root_path
  end

end
