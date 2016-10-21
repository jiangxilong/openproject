require 'capybara/rspec'
require 'rack_session_access/capybara'

RSpec.configure do |config|
  Capybara.default_max_wait_time = 4
end

Rails.application.config do
  config.middleware.use RackSessionAccess::Middleware
end

Capybara.register_driver :selenium do |app|
  require 'selenium/webdriver'

  Selenium::WebDriver::Firefox::Binary.path = ENV['FIREFOX_BINARY_PATH'] ||
    Selenium::WebDriver::Firefox::Binary.path

  capabilities = Selenium::WebDriver::Remote::Capabilities.internet_explorer
  capabilities["elementScrollBehavior"] = 1

  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['intl.accept_languages'] = 'en'

  profile['browser.download.dir'] = DownloadedFile::PATH.to_s
  profile['browser.download.folderList'] = 2

  profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv'

  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    profile: profile,
    desired_capabilities: capabilities
  )
end

Capybara.javascript_driver = :selenium
