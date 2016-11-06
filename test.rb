require './page.rb'

page = Page.new

page.enter_keyword("just a keyword")
page.verify_results("just a keyword")
