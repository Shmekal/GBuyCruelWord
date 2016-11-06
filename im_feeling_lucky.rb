require './page.rb'

keyword = process_ARGV(ARGV)

page = Page.new

page.enter_keyword(keyword, true)
page.verify_results(keyword)
