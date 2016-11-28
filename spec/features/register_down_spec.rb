# spec/register_down_spec.rb

require 'page'

RSpec.feature "Verify basic query search results" do

  before do
    @page = Page.new
    @page.visit 'https://google.com'
  end

  feature "Downcase input" do

    before { @page.enter_keyword 'monster' }

    feature "First result" do
      scenario "Title contains inputted keyword Upcase" do
        expect(@page.first_result_title).to include('Monster')
      end

      scenario "URL contains inputted keyword Downcase" do
        expect(@page.first_result_url).to include('monster')
      end

      scenario "Description contains inputted keyword Upcase" do
        expect(@page.first_result_description).to include('Monster')
      end
    end

  end

end
