require 'time'
require "./Parser.rb"

start_time = Time.now

#Parser.new.scrapper_page("https://www.petsonic.com/dermatitis-y-problemas-piel-para-perros/")
Parser.new.scrape_category_page(ARGV[0])

work_time = Time.now - start_time
puts "Time of parsing: #{(work_time/60).to_int.to_s.rjust(2, "0")}:#{(work_time%60).to_int.to_s.rjust(2, "0")}"
