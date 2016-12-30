puts "Seeding DB..."

User.create!(email: "luke@dev.com", password: "loplop", password_confirmation: "loplop")

dec = Date.new(2016, 12, 1)
dec_length = Date.new(2016, 12, -1).day

jan = Date.new(2017, 1, 1)
jan_length = Date.new(2017, 1, -1).day

Month.create(name: dec.strftime("%B"), length: dec_length)
Month.create(name: jan.strftime("%B"), length: jan_length)

row   = 0
block = dec.strftime("%w").to_i
date_day = 1

42.times do |i|

  if i >= block && date_day <= dec_length
    Day.create(
      month_id: 1,
      row:       row,
      block:     block,
      clickable: true,
      practiced: false,
      date:      Date.new(2016, 12, date_day)
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
      block:     i,
      clickable: false,
      practiced: false
    )
  end


  # if block < 6
    # block += 1
  # else
    # block = 0
    # row += 1
  # end

end
