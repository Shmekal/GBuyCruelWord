# spec/register_down_spec.rb

require 'page'

RSpec.feature "Verify query search results" do

  subject { Page.new }

  background do
    subject.visit 'https://google.com'
    subject.enter_keyword keyword
  end

  feature "Use one-word keyword" do
    context "Ignore case" do
      context "Downcase input" do
        given(:keyword) {'monster'}

        scenario "Title contains inputted keyword Upcase" do
          expect(subject.first_result_title).to include(keyword.capitalize)
        end

        scenario "URL contains inputted keyword Downcase" do
          expect(subject.first_result_url).to include(keyword.downcase)
        end

        scenario "Description contains inputted keyword Upcase" do
          expect(subject.first_result_description).to include(keyword.capitalize)
        end
      end # context downcase


      context "Upcase input" do
        given(:keyword) {'Monster'}

        scenario "Title contains inputted keyword Upcase" do
          expect(subject.first_result_title).to include(keyword.capitalize)
        end

        scenario "URL contains inputted keyword Downcase" do
          expect(subject.first_result_url).to include(keyword.downcase)
        end

        scenario "Description contains inputted keyword Upcase" do
          expect(subject.first_result_description).to include(keyword.capitalize)
        end
      end # context upcase

      context "Mixed case input" do
        given(:keyword) {'mONSteR'}

        scenario "Title contains inputted keyword Upcase" do
          expect(subject.first_result_title).to include(keyword.capitalize)
        end

        scenario "URL contains inputted keyword Downcase" do
          expect(subject.first_result_url).to include(keyword.downcase)
        end

        scenario "Description contains inputted keyword Upcase" do
          expect(subject.first_result_description).to include(keyword.capitalize)
        end
      end # context mixed
    end # context ignore


    context "cyryllic symbols" do
      given(:keyword) {'Монстр'}

      scenario "Title contains inputted cyryllic keyword" do
        expect(subject.first_result_title).to include(keyword.capitalize)
      end

      scenario "Description contains inputted cyryllic keyword" do
        expect(subject.first_result_description).to include(keyword.capitalize)
      end
    end
  end # feature one-word


  feature "Use multi-word keyword" do
    given(:keyword) {'Buy Car Online'}

    before { subject.enter_keyword 'Buy Car Online' }

    scenario "Title contains inputted keyword" do
      expect(subject.first_result_title).to include('Buy', 'Car', 'Online')
    end

    scenario "Description contains inputted keyword" do
      expect(subject.first_result_description).to include('buy', 'car', 'online')
    end
  end
end # feature verify search
