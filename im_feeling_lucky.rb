require './page.rb'

keyword = process_ARGV(ARGV)

page = Page.new

page.enter_keyword(keyword, {im_feeling_lucky: true})
page.verify_results(keyword)
