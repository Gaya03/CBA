require 'spec_helper'

describe "Test postings / homepage as an admin" do

  describe "Test hover-menus for admin when reading posts" do
    it "Hover a title should show the menu", :js => true do
      SpecDataHelper::cleanup_database
      SpecDataHelper::create_default_userset
      SpecDataHelper::create_posting_for('admin@iboard.cc',
        :title => 'My first posting',
        :body  => 'This is my very first posting',
        :is_draft => false)
      SpecDataHelper::log_in_as "admin@iboard.cc"
      visit root_path
      page.should have_content("My first posting")
      begin
        page.find_link("My first posting").trigger('mouseover')
      rescue Capybara::NotSupportedByDriverError => e
        puts "**** Browser/driver doesn't support trigger - #{e.inspect} ****"
      end
    end
  end

end