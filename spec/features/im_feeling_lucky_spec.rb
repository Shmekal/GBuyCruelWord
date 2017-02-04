# spec/features/im_feeling_lucky.rb

require 'page'

feature "Verify Im Feeling Lucky result" do

  background do
    @page = Home.new
    @page.navigate_to_home_page
    @page.fill_search_im_feeling_lucky keyword
    @page = @page.navigate_and_parse_search_page
    @page.submit_im_feeling_lucky_search
  end

  feature "latin symbols" do
    context "blah" do
      given(:keyword) {'monster'}

      scenario "Opened page contains keyword" do
        expect(@page.entire_page_text).to include(keyword)
      end
    end










  end
end