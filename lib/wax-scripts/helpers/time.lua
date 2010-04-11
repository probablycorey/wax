wax.time = {}

function wax.time.minutes(number)
  return number * 60
end

function wax.time.hours(number)
  return number * time.minutes(60)
end

function wax.time.days(number)
  return number * time.hours(24)
end