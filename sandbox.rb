snippet = ""

"hello:corey:dale:johnson:".scan(/([^\:]+):/).each_with_index do |var, index|
  name = (index == 0) ? "first" : var.first
  snippet += "${#{index}:#{name}}"
end

puts snippet