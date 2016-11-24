require 'capybara'
require 'capybara/dsl'
require 'uri'

# workaround to keep browser alive for debugging after test completion
# Capybara::Selenium::Driver.class_eval do
#   def quit
#     puts "Press RETURN to quit the browser"
#     $stdin.gets
#     @browser.quit
#   rescue Errno::ECONNREFUSED
#     # Browser must have already gone
#   end
# end

class Page
  include Capybara::DSL

  def initialize
    Capybara.current_driver = :selenium
  end

  def enter_keyword(keyword, params={})
    # also can be executed here or in the initialize method
    # visit 'https://google.com'
    fill_in 'q', with: keyword
    locator = params[:im_feeling_lucky] ? '.sbsb_i.sbqs_b' : '.lsb'
    find(locator, match: :first).click
  end

  def parse_first_result
    find('.g', match: :first).text.downcase
  end

  def parse_all_sites
    within('.srg') do
      site_list = []
      all('._Rm').each { |i| site_list << i.text }
      site_list
    end
  end

end
