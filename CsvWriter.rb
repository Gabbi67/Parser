require 'csv'

class CsvWriter
  def info_write
    CSV.open("#{ARGV[1]}.csv", 'a') {|csv| csv << ["Name; Price; Image"]} # записывает в первую строку название колонок
  end

  def csv_write(weight, cost, name, image_link)
    weight.zip(cost).each_with_index { |variation_info_arr, index|
      puts "#{index+1}) #{variation_info_arr[0].text} - #{variation_info_arr[1].text}" # выводит в консоль пары вес-цена каждого товара
      string_to_write = "#{name.text.strip} - #{variation_info_arr[0].text}; #{variation_info_arr[1].text.sub(' €','')}; #{image_link.text}" # собирает строку для записи в цсв, исключая у цена знак "€"
      CSV.open("#{ARGV[1]}.csv", 'a') {|csv| csv << [string_to_write]}
    }
  end

  def dif_csv_write(cost, name, image_link)
      puts "Price #{cost.text}"
      string_to_write = "#{name.text.strip}; #{cost.text.sub(' €','')}; #{image_link.text}" # собирает строку для записи в цсв, исключая у цена знак "€"
      CSV.open("#{ARGV[1]}.csv", 'a') {|csv| csv << [string_to_write]}
  end
end

