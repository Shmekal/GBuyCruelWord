require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'uri'
require 'site_prism'
require 'additional_methods.rb'

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

  def navigate_and_parse_search_page
    SearchResults.new
  end
end

class SearchResults < Page
  section :search_field, SearchFieldSection, '.sbibod'
  sections :search_results, SearchResultSection, '.rc'

  def initialize
    wait_for_search_results(3)
  end

  def first_result_title
    search_results.first.title.text
  end

  def first_result_url
    result = search_results.first.url.text
    symbols_to_replace = ['_', '-']
    symbols_to_replace.each { |s| result.gsub!(s, ' ') }
    result
  end

  def first_result_description
    search_results.first.description.text
  end

  def all_titles
    search_results.map { |result| result.title.text.downcase }
  end

  def all_urls
    search_results.map { |result| result.url.text }
  end

  def all_descriptions
    search_results.map { |result| result.description.text.downcase }
  end
end
