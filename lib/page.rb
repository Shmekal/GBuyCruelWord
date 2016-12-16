require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'uri'

# # workaround to keep browser alive for debugging after test completion
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

  def enter_keyword(keyword)
    fill_in 'q', with: keyword
    # locator = params[:im_feeling_lucky] ? '.sbsb_i.sbqs_b' : '.lsb'
    find('.sbico', match: :first).click
  end

  def parse_all_sites
    within('.srg') do
      site_list = []
      all('._Rm').each { |i| site_list << i.text }
      site_list
    end
  end

  def first_result_title
    parse_first_result(:title)
  end

  def first_result_url
    parse_first_result(:url)
  end

  def first_result_description
    parse_first_result(:description)
  end

  private

  def parse_first_result(destination)
    locator =
      case destination
        when :title
          '.r'
        when :url
          '.f.kv'
        when :description
          '.st'
      end

    within(find('.rc', match: :first)) do
      find(locator).text
    end
  end

end
