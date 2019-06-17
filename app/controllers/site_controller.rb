class SiteController < ApplicationController
  # protect_from_forgery with: :exception
  before_action :authenticate_user!, only: [:practiced]

  def index
    # if first_of_the_month?
    #   time = Time.new
    #   month_length = Date.new(Time.new.year, Time.new.month, -1).day

    #   new_yr = time.year.to_s
    #   new_mm = time.month.to_s.length < 2 ? "0" + time.month.to_s : time.month.to_s
    #   yyyymm = new_yr + new_mm

    #   Month.create(name: time.strftime("%B"), length: month_length, yyyymm: yyyymm)

    #   populate_new_month(month_length)
    # end

    @current_month = params[:id] ? Month.find(params[:id]) : Month.last

    @days   = Day.where(month_id: @current_month.id).order(:id)
    @hrs    = total_hrs_practiced()
    @months = Month.all.reverse

    @monthly_practice_minutes = @months.map { |m| ((Day.where(month_id: m.id).sum(:minutes).to_f) / 60).round(2) }
    @mms = Day.where(month_id: @current_month.id).sum(:minutes)

    # yearly heat map = yhm
    @yhm_iterator = 0
    @yhm = []
    Month.last(12).each do |m|
      Day.where(month_id: m, clickable: true).order(:id).each do |d|
        @yhm.push d
      end
    end
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
    if params[:practiced] == "1"
      # defaults
      color     = heat_color(1)
      txt_color = heat_color(10)
      streak    = 1

      # picks up streak where last left,
      # ie it will ignore empty blocks from a new month start / old month finish
      prev_day = []
      i = 1
      until prev_day.empty? != true
        prev_day = Day.where(id: params[:day_id].to_i - i, clickable: true)
        i += 1
      end

      if prev_day[0].streak != nil
        streak = prev_day[0].streak.to_i + 1
        streak = streak > 10 ? 10 : streak

        color     = heat_color(streak)
        txt_color = heat_color(11 - streak)
      end

      Day.update(params[:day_id],
                  practiced:    params[:practiced],
                  streak:       streak,
                  minutes:      params[:minutes],
                  color:        color,
                  text_color:   txt_color
                )
    else
      # TODO: recalculate streak if somehow broken
      Day.update(params[:day_id],
                  practiced:    params[:practiced],
                  streak:       nil,
                  minutes:      nil,
                  color:        "transparent",
                  text_color:   "black"
                )
    end

    data = {:message => "POST practiced", :color => color, :text_color => txt_color}
    render :json => data, :status => :ok
  end

  def iot
    # TODO: error handling, notification, edge cases
    day = Day.where(date: Time.now.to_s[0..9])

    # defaults
    color     = heat_color(1)
    txt_color = heat_color(10)
    streak    = 1

    prev_day = []
    i = 1
    until prev_day.empty? != true
      prev_day = Day.where(id: day[0].id.to_i - i, clickable: true)
      i += 1
    end

    if prev_day[0].streak != nil
      streak = prev_day[0].streak.to_i + 1
      streak = streak > 10 ? 10 : streak

      color     = heat_color(streak)
      txt_color = heat_color(11 - streak)
    end

    if day[0].minutes == nil
      Day.update(day[0].id, minutes: 0)
    else
      practiced = ((Time.now - day[0].updated_at) / 60).round

      Day.update(day[0].id,
                  minutes:      practiced,
                  practiced:    1,
                  streak:       streak,
                  color:        color,
                  text_color:   txt_color
                )
    end

    redirect_to root_path
  end

  def heat_color(streak)
    colors = [ "", "#E3F2FD", "#B8DEFB", "#90CAF9", "#64B5F6", "#42A5F5", "#2196F3", "#1E88E5", "#1976D2", "#1565C0", "#0047A1" ]

    colors[streak]
  end

end
