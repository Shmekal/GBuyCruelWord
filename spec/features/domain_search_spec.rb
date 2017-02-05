# spec/features/domain_search_spec.rb

require 'page'

feature "Verify specific domain search results" do

  background do
    @page = Home.new
    @page.navigate_to_home_page
    @page.fill_search_field_with keyword
    @page = @page.navigate_and_parse_search_page
  end

  feature "Use keyword with domain" do
    given(:keyword) {'liverpool soccer.com'}

    scenario "All titles contain keyword" do
      # expect(@page.all_titles).to all( include(keyword.without_domain) )
# smth is wrong with 'all' mathcher, thus ugly workaround had to be reinvented
      expect(@page.all_titles).to satisfy do |v|
# also .without_domain method results nil if invoced inside include? block
# so I had to declare a variable to be passed there
        matcher = keyword.without_domain
        v.all? { |s| s.include?(matcher) }
      end
    end

    scenario "Not all results belong to chosen domain" do
      # expect(@page.all_urls).not_to all( include(keyword.domain) )
      expect(@page.all_urls).not_to satisfy do |v|
        v.all? { |s| s.include?(keyword.domain) }
      end
    end
  end

  feature"Use keyword with domain using 'site:' feature" do
    given(:keyword) {'manchester site:soccer.com'}

    scenario "All titles contain keyword" do
      # expect(@page.first_result_title).to include(keyword.without_domain)
      expect(@page.all_titles).to satisfy do |v|
        matcher = keyword.without_domain
        v.all? { |s| s.include?(matcher) }
      end
    end

    scenario "All results belong to chosen domain" do
      # expect(@page.all_urls).to all( include(keyword.domain) )
      expect(@page.all_urls).to satisfy do |v|
        v.all? { |s| s.include?(keyword.domain) }
      end
    end
  end

end
