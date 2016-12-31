puts "Seeding DB..."
puts

User.create!(email: "luke@dev.com", password: "loplop", password_confirmation: "loplop")

# December
# month = Date.new(2016, 12, 1)
# month_length = Date.new(2016, 12, -1).day
# Month.create(name: month.strftime("%B"), length: month_length)

# January
month = Date.new(2017, 1, 1)
month_length = Date.new(2017, 1, -1).day
Month.create(name: month.strftime("%B"), length: month_length)

# February
# month = Date.new(2017, 2, 1)
# month_length = Date.new(2017, 2, -1).day
# Month.create(name: month.strftime("%B"), length: month_length)

# March
# month = Date.new(2017, 3, 1)
# month_length = Date.new(2017, 3, -1).day
# Month.create(name: month.strftime("%B"), length: month_length)

row   = 0
# numbered day of week, ie Sun 0, Mon 1
block = month.strftime("%w").to_i
date_day = 1

42.times do |i|

  if i >= block && date_day <= month_length
    Day.create(
      month_id: 1,
      row:       row,
      block:     block,
      clickable: true,
      practiced: 0,
      date:      Date.new(2017, 3, date_day)
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
      practiced: 0
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
