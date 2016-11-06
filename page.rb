require 'capybara'
require 'capybara/dsl'


Capybara::Selenium::Driver.class_eval do
  def quit
    puts "Press RETURN to quit the browser"
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

  def enter_keyword(keyword, params={})
    visit 'https://google.com'
    fill_in 'q', with: keyword
    locator = params[:im_feeling_lucky] ? '.sbsb_i.sbqs_b' : '.lsb'
    find(locator, match: :first).click
  end

  def verify_basic_search_results(keyword, params={})
    # first result
    puts 'First result:'
    if params[:force_inclusion]
      check_force_inclusion('.g', keyword)
    else
      check_keyword_presence('.g', keyword)
    end

    # page title
    puts 'Page Title:'
    if title.include? keyword
      puts "'#{keyword}' keyword is present"
    else
      puts "'#{keyword}' keyword is not present"
    end

    # page url
    match_url = /#q=(.*)/.match(current_url)
    match_url = make_gsubs(match_url[1])
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
        puts "'#{keyword}' keyword is found partially by word(s) - #{words_found}"
      else
        puts "'#{keyword}' is NOT found"
      end
    end
  end # check_keyword_presence

  def check_force_inclusion(locator, keyword)
    phrases = keyword.scan(/"(.*?)"/).flatten
    object = find(locator, match: :first).text.downcase
    if phrases.all? { |phrase| object.include?(phrase)}
      puts "all force inclusion phrases are present - #{phrases}"
    else
      # here we change the logic to a bit to output
      # more precisely what phrases were/weren't found
      puts "not all phrases were found"
    end
  end # check_force_inclusion

  def make_gsubs(string)
    gsub_pairs = [['+',' '], ['%2B','+'], ['%27','\''], ['%22','"']]
    gsub_pairs.each{ |pair| string.gsub!(pair.first, pair.last) }
    string
  end
end
