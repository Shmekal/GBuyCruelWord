# spec/features/group_search_spec.rb

require 'page'

feature "Verify 'Exact Search' feature" do

  background do
    @page = Home.new
    @page.navigate_to_home_page
    @page.fill_search_field_with keyword
    @page = @page.navigate_and_parse_search_page
  end

  feature "Use two-word keyword without quotes" do
    given(:keyword) {'exact search'}

    scenario "Title doesn't contain full keyword" do
      expect(@page.first_result_title).not_to include(keyword)
    end

    scenario "URL doesn't contain full keyword" do
      expect(@page.first_result_url).not_to include(keyword)
    end

    scenario "Description doesn't contain full keyword" do
      expect(@page.first_result_description).not_to include(keyword)
    end
  end

  feature "Use two-word keyword with quotes" do
    given(:keyword) {'"exact search"'}

    scenario "Title contains full keyword" do
      expect(@page.first_result_title).to include(keyword.without_quotes)
    end

    scenario "URL contains full keyword" do
      expect(@page.first_result_url).to include(keyword.without_quotes)
    end

    scenario "Description contains full keyword" do
      expect(@page.first_result_description).to include(keyword.without_quotes)
    end
  end
end
