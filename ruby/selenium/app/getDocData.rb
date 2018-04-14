require 'selenium-webdriver'

NONSTOP_JDOCS_URL = 'http://www.hpe.com/info/nonstop-jdocs'
NONSTOP_DOCVIEW_URL = 'https://support.hpe.com/hpsc/doc/public/display?docLocale=en_US&docId=emr_na-c05274797'
#<a id="listresult_emr_na-a00027508en_us" class="grommetux-anchor"><span class="title_div">NonStop Server for Java 4.0 API and Reference</span></a>
DOWNLOAD_DIR   = '/data/download'
OUT_FILE = '/data/docs.txt'

#  WebDriver
caps = Selenium::WebDriver::Remote::Capabilities.chrome(
  chromeOptions:  {
    args: ["--disable-extensions", "--disable-print-preview"],
    prefs: {
      "download.default_directory": DOWNLOAD_DIR,
      "download.prompt_for_download": false,
      "download.directory_upgrade": true,
      "plugins.plugins_disabled": ["Chrome PDF Viewer"],
      "plugins.always_open_pdf_externally": true,
    }
  }
)

host = ENV['SELENIUM_SERVER']
driver = Selenium::WebDriver.for :remote, url: "http://#{host}/wd/hub", desired_capabilities: caps

driver.navigate.to NONSTOP_JDOCS_URL


# waitうまく行かなかったので、sleepで待たせる
# wait = Selenium::WebDriver::Wait.new(timeout: 10)
(1..100).each{|i|
  sleep(10)
  loadMoreAnchor = driver.find_elements(:xpath, "//a[@id='more_results_100']")
  if loadMoreAnchor.size > 0 then
    loadMoreAnchor[0].click
    printf( "clicked(%02d) & sleep 10 second !!\n",i)
  else
    printf( "No More loadMore.Anchor!!! Break!!!\n")
    break
  end
#  wait.until{ driver.find_element(:id, 'loadMore') }
}

driver.save_screenshot "/data/screen.png"
File.open("/data/page_source.txt","w"){|f| f.puts(driver.page_source)}
elements = driver.find_elements(:xpath, "//a[@class='grommetux-anchor']")
File.open(OUT_FILE,"w"){|f|
  elements.each{|e|
    f.printf("%-20s (%s)\n",e.attribute('id'),e.text)
  }
}



driver.quit

