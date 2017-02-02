puts "Seeding DB..."
puts

# User.create(username: "lukekedz", email: "luke@dev.com", password: "loplop", password_confirmation: "loplop")

# doubles for creation method in controller when 1st of month

# January
month = Date.new(2017, 1, 1)
month_length = Date.new(2017, 1, -1).day
Month.create(name: month.strftime("%B"), length: month_length, yyyymm: "201701")

# initial day for edge case on 1/1 streak counting
Day.create(
  month_id:  -1,
  row:       -1,
  block:     -1,
  clickable: false,
  practiced: 0,
)

row = 0
# numbered day of week, ie Sun 0, Mon 1
block = month.strftime("%w").to_i
date_day = 1

42.times do |i|

  if i >= block && date_day <= month_length
    Day.create(
      month_id:   1,
      row:        row,
      block:      block,
      clickable:  true,
      practiced:  0,
      date:       Date.new(2017, 1, date_day),
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
      month_id: 1,
      row:       row,
      block:     (date_day > month_length ? block : i),
      clickable: false,
      practiced: 0,
      color:     "transparent"
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
