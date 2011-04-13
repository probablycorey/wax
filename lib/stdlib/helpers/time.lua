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

-- Pattern match formats found here http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
function wax.time.formatDate(date, pattern)
  if not wax.time._outputFormatter then wax.time._outputFormatter = NSDateFormatter:init() end
  wax.time._outputFormatter:setDateFormat(pattern or "MMMM d")
  return wax.time._outputFormatter:stringFromDate(date)
end

-- Pattern match formats found here http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
function wax.time.parseDate(date, pattern)
  if not wax.time._inputFormatter then wax.time._inputFormatter = NSDateFormatter:init() end
  wax.time._inputFormatter:setDateFormat(pattern or "yyyy-MM-dd'T'HH:mm:ss'Z'")
  return wax.time._inputFormatter:dateFromString(date)
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

function wax.time.endOfDay(date)
  local calendar = NSCalendar:currentCalendar()
  local dateComponents = calendar:components_fromDate(-1, date)
  local newComponents = NSDateComponents:init()
  newComponents:setYear(dateComponents:year())
  newComponents:setMonth(dateComponents:month())
  newComponents:setDay(dateComponents:day())
  newComponents:setHour(24)
  newComponents:setMinute(59)
  newComponents:setSecond(59)
  
  return calendar:dateFromComponents(newComponents)
end

function wax.time.timeAgoInWords(firstDate, secondDate)
  local difference = (secondDate or NSDate:date()):timeIntervalSince1970() - firstDate:timeIntervalSince1970()
  local seconds = math.abs(difference)
  local minutes = math.floor(seconds / 60)
  local hours = math.floor(minutes / 60)
  local days = math.floor(hours / 24)
  local months = math.floor(days / 30)

  if minutes <= 1 then return "less than a minute"
  elseif minutes <= 44 then return ("%d minutes"):format(minutes)
  elseif minutes <= 89 then return "about 1 hour"
  elseif hours <= 24 then return ("about %d hours"):format(hours)
  elseif hours <= 47 then return "1 day"
  elseif days <= 29 then return ("%d days"):format(days)
  elseif days <= 59 then return "about 1 month"
  elseif months <= 15 then return "about 1 year"
  elseif months <= 22 then return "over 1 year"
  elseif years < 2 then return "almost 2 years"
  elseif minutes <= 1051199 then return "about 1 year"
  else return ("over %d years"):format(years)
  end
end