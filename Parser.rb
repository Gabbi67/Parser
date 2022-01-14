require 'nokogiri'
require 'open-uri'
require "./CsvWriter.rb"


SEP = "-"*100.freeze # две разделительные черты для вывода в консоль
D_SEP = "="*100.freeze
PAGE_PRODUCT_XPATH = "//a[@class='product-name']/@href".freeze
WEIGHT_XPATH = "//span[@class='radio_label']".freeze
COST_XPATH = "//span[@class='price_comb']".freeze
NAME_XPATH = "//h1[@class='product_main_name']".freeze
DIF_COST_XPATH = "//span[@id='our_price_display']".freeze
NEXT_PAGE_XPATH = "//link[@rel='next']/@href".freeze
IMAGE_XPATH = "//img[@id='bigpic']/@src".freeze


class Parser
  def initialize
    puts D_SEP
    @page_num = 1 # переменные которые считают количество стрраниц, предметов и записанных строк
    @items_num = 0
    @string_written = 0
    CsvWriter.new.info_write
  end

  def scrape_category_page(url)
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    puts "Page #{@page_num}: #{url}"
    @page_num += 1
    puts "Products on page: #{scrape_xpath(PAGE_PRODUCT_XPATH, doc).length}"
    scrape_xpath(PAGE_PRODUCT_XPATH, doc).each_with_index {|item_url, index| scrape_product(item_url, index) } #парсит одну стрницу категории и для каждого товара вызывает метод парсинга
    @items_num += scrape_xpath(PAGE_PRODUCT_XPATH, doc).length
    puts SEP
    puts "Items parsed: #{@items_num}"
    puts "Variations written: #{@string_written}"
    next_page(doc)
  end

  def scrape_product(item_url, index)
    @items_num
    puts SEP
    puts "Product #{index+1}: #{item_url}"
    html = URI.open(item_url)
    doc = Nokogiri::HTML(html)
    name = scrape_xpath(NAME_XPATH, doc)
    image_link = scrape_xpath(IMAGE_XPATH, doc)
    puts "Product name: #{name.text}"
    puts "Image link: #{image_link}"
    cost  = scrape_xpath(COST_XPATH, doc).text.to_s == '' ? scrape_xpath(DIF_COST_XPATH, doc) : scrape_xpath(COST_XPATH, doc)
    weight = scrape_xpath(WEIGHT_XPATH, doc).text.to_s == '' ? CsvWriter.new.dif_csv_write(cost, name, image_link) : scrape_xpath(WEIGHT_XPATH, doc)
    CsvWriter.new.csv_write(weight, cost, name, image_link) if scrape_xpath(WEIGHT_XPATH, doc).text.to_s != ''
    @string_written += cost.size
  end

  def scrape_xpath(xpath, doc)
    doc.xpath(xpath).each {|element| element} # делает поиск элемента с помощтю xpath и вовзвращает сам элемент
  end

  def next_page(doc)
    puts D_SEP
    doc.xpath(NEXT_PAGE_XPATH).each { |next_page_url| scrape_category_page(next_page_url)} # определяет ссылку на следующую страницу категории, если её нет - скрипт заканчивает работу
  end

end
