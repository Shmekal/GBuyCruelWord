require './page.rb'

keyword = process_ARGV(ARGV)

page = Page.new

page.enter_keyword(keyword)
page.verify_basic_search_results(keyword, site: true)
