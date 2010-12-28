#!/usr/local/bin/ruby

i = 145
widths = String.new
while i < 400 do
  widths += "#{i},"
  i += 10
end

puts "WIDTHS = [#{widths}]"

i = 20
sidewalls = String.new
while i < 90 do
  sidewalls += "#{i},"
  i += 5
end

puts "SIDEWALLS = [#{sidewalls}]"


i = 10
diameters = String.new
while i < 31 do
  diameters += "#{i},"
  i += 1
end

puts "DIAMETERS = [#{diameters}]"

i = 5
diameters = String.new
while i <= 100 do
  diameters += "#{i},"
  i += 5
end

puts "DIAMETERS = [#{diameters}]"


