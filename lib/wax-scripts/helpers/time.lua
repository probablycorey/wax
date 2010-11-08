wax.time = {}

function wax.time.minutes(number)
  return number * 60
end

function wax.time.hours(number)
  return number * wax.time.minutes(60)
end

function wax.time.days(number)
  return number * wax.time.hours(24)
end

function wax.time.beginingOfDay(date)
  local calendar = NSCalendar:currentCalendar()
  local dateComponents = calendar:components_fromDate(-1, date)
  local newComponents = NSDateComponents:init()
  newComponents:setYear(dateComponents:year())
  newComponents:setMonth(dateComponents:month())
  newComponents:setDay(dateComponents:day())
  
  return calendar:dateFromComponents(newComponents)
end