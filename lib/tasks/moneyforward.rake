namespace :moneyforward do
  task import: :environment do
    require 'csv'
    require 'selenium-webdriver'
    require 'webdriver-user-agent'

    TIMOUT = 10

    download_path = File.absolute_path('./csv')

    download_preference = {
      'prompt_for_download' => false,
      'default_directory' => download_path,
      'directory_upgrade' => true
    }
    Selenium::WebDriver.logger.output = File.join('./log/', 'selenium.log')
    Selenium::WebDriver.logger.level = :warn
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, download_preference)
    options.add_argument('--no-sandbox')
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--lang=ja-JP')
    options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36')
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.manage.timeouts.implicit_wait = TIMOUT
    wait = Selenium::WebDriver::Wait.new(timeout: TIMOUT)

    begin
      driver.get('https://id.moneyforward.com/sign_in/email?client_id=2WND7CAYV1NsJDBzk13JRtjuk5g9Jtz-4gkAoVzuS_k&nonce=b0cb75eb0351729cd986cfcd1b8dc299&redirect_uri=https%3A%2F%2Fmoneyforward.com%2Fauth%2Fmfid%2Fcallback&response_type=code&scope=openid+email+profile+address&state=c5d7e1f6373ce5adb9e9ceb5dd8dad31')
      driver.find_element(:class, 'inputItem').send_keys(Rails.application.credentials.moneyforward[:email])
      driver.find_element(:class, 'submitBtn').click
      driver.find_element(:class, 'inputItem').send_keys(Rails.application.credentials.moneyforward[:password])
      driver.find_element(:class, 'submitBtn').click
      driver.get('https://moneyforward.com/')
      driver.find_element(:class, 'web-sign-in').click
      driver.find_element(:class, 'submitBtn').click
      driver.get('https://moneyforward.com/accounts')
      driver.find_element(:class, 'aggregation-queue-all').find_element(:tag_name, 'a').click
      today = Date.today
      period = Period.target_period(today) || Period.next_month_initialize
      FileUtils.rm_rf('csv')
      driver.get("https://moneyforward.com/cf/csv?month=#{period.month}&year=#{period.year}")
      Dir.chdir('csv')
      is_download = false
      until is_download
        download_incomplete_files = Dir.glob('*.crdownload')
        is_download = download_incomplete_files.blank?
      end
      filename = Dir.glob('*.csv').first
      file = File.open(filename, 'r')
      if period.id.nil?
        filename = filename.split('_')
        filename.shift
        beginning_date = filename[0]
        end_date = filename[1]
        target_date = filename[1].split('-')
        period.beginning_date = beginning_date
        period.end_date = end_date
        period.create
      end
      Expense.import!(file, period.id)
      Income.import!(file, period.id)

      Dir.chdir('..')
      FileUtils.rm_rf('csv')
    rescue Selenium::WebDriver::Error::NoSuchElementError
      p 'no such element error!!'
      return
    end

    driver.quit
  end
end
