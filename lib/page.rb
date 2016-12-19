require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'uri'
require 'site_prism'

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

class SearchFieldSection < SitePrism::Section
  element :text_input, '#lst-ib'
  element :voice_imput, '.gsri_a'
  element :search_button, '.sbico'
end

class SearchResultSection < SitePrism::Section
  element :title, '.r'
  element :url, '.f.kv'
  element :description, '.st'

end

class Page < SitePrism::Page
  include Capybara::DSL

  def initialize
    Capybara.current_driver = :selenium
  end
end

class Home < Page
  set_url 'https://www.google.com'
  section :search_field, SearchFieldSection, '.sbibod'
end

class SearchResults < Page
  section :search_field, SearchFieldSection, '.sbibod'
  sections :search_results, SearchResultSection, '.rc'
end



# class Page
#   include Capybara::DSL

#   def initialize
#     Capybara.current_driver = :selenium
#   end

#   def enter_keyword(keyword)
#     fill_in 'q', with: keyword
#     # locator = params[:im_feeling_lucky] ? '.sbsb_i.sbqs_b' : '.lsb'
#     find('.sbico', match: :first).click
#   end

#   def parse_all_sites
#     within('.srg') do
#       site_list = []
#       all('._Rm').each { |i| site_list << i.text }
#       site_list
#     end
#   end

#   def first_result_title
#     parse_first_result(:title)
#   end

#   def first_result_url
#     parse_first_result(:url)
#   end

#   def first_result_description
#     parse_first_result(:description)
#   end

#   private

#   def parse_first_result(destination)
#     locator =
#       case destination
#         when :title
#           '.r'
#         when :url
#           '.f.kv'
#         when :description
#           '.st'
#       end

#     within(find('.rc', match: :first)) do
#       find(locator).text
#     end
#   end

# end
