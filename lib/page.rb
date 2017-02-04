require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara-webkit'
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
  element :voice_input, '.gsri_a'
  element :search_button, '.sbico'
end

class SearchSuggestionsSection < SitePrism::Section
  elements :suggestions, '.sbsb_b [role=option]'
  element :im_feeling_lucky, '.sbsb_i.sbqs_b'
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

  def navigate_to_home_page
    self.load
  end

  def fill_search_field_with(keyword)
    wait_for_search_field(3)
    search_field.text_input.set keyword
    search_field.search_button.click
  end

  def fill_search_im_feeling_lucky(keyword)
    wait_for_search_field(3)
    search_field.text_input.set keyword
  end

  def navigate_and_parse_search_page
    SearchResults.new
  end
end

class SearchResults < Page
  section :search_field, SearchFieldSection, '.sbtc'
  sections :search_results, SearchResultSection, '.rc'
  section :search_suggestions, SearchSuggestionsSection, '.gstl_0.sbdd_a'

  def initialize
    wait_for_search_results(3)
  end

  def first_result_title
    search_results.first.title.text
  end

  def first_result_url
    search_results.first.url.text
  end

  def first_result_description
    search_results.first.description.text
  end

  def submit_im_feeling_lucky_search
    wait_for_search_suggestions(3)
    search_suggestions.suggestions.first.trigger(:mouseover)
    search_suggestions.im_feeling_lucky.click
  end
end
