require 'capybara'
require 'capybara/dsl'


Capybara::Selenium::Driver.class_eval do
  def quit
    puts "Press RETURN to quit the browsruer"
    $stdin.gets
    @browser.quit
  rescue Errno::ECONNREFUSED
    # Browser must have already gone
  end
end


def process_ARGV(keyword)
  if keyword.empty?
    puts 'Please pass the keyword next to the test filename'
  else
    keyword = keyword.join(' ')
  end
end

class Page
  include Capybara::DSL

  def initialize
    Capybara.current_driver = :selenium
    # Capybara.javascript_driver = :webkit
  end

  def enter_keyword(keyword, im_feeling_lucky=false)
    visit 'https://google.com'
    fill_in 'q', with: keyword
    locator = im_feeling_lucky ? '.sbsb_i.sbqs_b' : '.lsb'
    find(locator, match: :first).click
  end

  def verify_basic_search_results(keyword)
    # first result
    puts 'First result: '
    check_keyword_presence('.g', keyword)

    # page title
    puts 'Page Title:'
    if title.include? keyword
      puts "'#{keyword}' keyword is present"
    else
      puts "'#{keyword}' keyword is not present"
    end

    # page url
    match_url = /#q=(.*)/.match(current_url)
    match_url = match_url[1].gsub('+',' ').gsub('%2B','+').gsub('%27','\'')
    puts 'URL:'
    if match_url == keyword
      puts "'#{keyword}' keyword is present"
    else
      puts "Mismatch! \n-expected: #{keyword}\n-found: #{match_url}"
    end
  end


  private

  def check_keyword_presence(locator, keyword)
    object = find(locator, match: :first).text.downcase
    if object.include?(keyword.downcase)
      puts "'#{keyword}' is found"
    else
      words_found = []
      keyword.split.each {|word| words_found << word if object.include?(word.downcase)}
      unless words_found.empty?
        puts "'#{keyword}' keyword if found partially by word(s) - #{words_found}"
      else
        puts "'#{keyword}' is NOT found"
      end
    end
  end # method
end
