# spec/basic_spec.rb

require 'page'

describe Page do


  before do
    @page = Page.new
    @page.visit 'https://google.com'
    @page.enter_keyword('Ruby')
  end

  # can be omitted and it affects nothing
  context "verify search results" do

    # Short version
    # it "first result includes 'Ruby'" do
    #   expect(@page.find('.g', match: :first).text.downcase).to include('ruby')
    # end

    describe ".parse_first_result" do
      context "first result" do
        it "includes 'ruby'" do
          expect(@page.parse_first_result).to include('ruby')
        end
      end
    end

    it "URL contains 'Ruby'" do
      expect(@page.current_url).to match(/#q=(Ruby)/)
    end

    it "title includes 'Ruby'" do
      expect(@page.title).to match(/^Ruby - /)
    end

  end

end