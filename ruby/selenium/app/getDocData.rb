require 'selenium-webdriver'

NONSTOP_JDOCS_URL = 'http://www.hpe.com/info/nonstop-jdocs'
NONSTOP_DOCVIEW_URL = 'https://support.hpe.com/hpsc/doc/public/display?docLocale=en_US&docId=emr_na-c05274797'
#<a id="listresult_emr_na-a00027508en_us" class="grommetux-anchor"><span class="title_div">NonStop Server for Java 4.0 API and Reference</span></a>
#
OUT_FILE = '/data/docs.txt'

#  WebDriver
host = ENV['SELENIUM_SERVER']
driver = Selenium::WebDriver.for :remote, url: "http://#{host}/wd/hub", desired_capabilities: :firefox

driver.navigate.to NONSTOP_JDOCS_URL


# waitkうまく行かなかったので、sleepで待たせる
# wait = Selenium::WebDriver::Wait.new(timeout: 10)
(1..100).each{|i|
  loadMoreButton = driver.find_elements(:xpath, "//button[@id='loadMore']")
  if loadMoreButton.size > 0 then
    loadMoreButton[0].click
    printf( "clicked(%02d) & sleep 10 second !!\n",i)
    sleep(10)
  else
    printf( "No More loadMore.Button!!! Break!!!\n")
    break
  end
#  wait.until{ driver.find_element(:id, 'loadMore') }
}

elements = driver.find_elements(:xpath, "//a[@class='grommetux-anchor']")
File.open(OUT_FILE,"w"){|f|
  elements.each{|e|
    f.printf("%-20s (%s)\n",e.attribute('id'),e.text)
  }
}



driver.quit

