require 'selenium-webdriver'


require 'selenium-webdriver'

NONSTOP_JDOCS_URL = 'http://www.hpe.com/info/nonstop-jdocs'

NONSTOP_DOCVIEW_URL = 'https://support.hpe.com/hpsc/doc/public/display?docLocale=en_US&docId=emr_na-c05274797'
#<a id="listresult_emr_na-a00027508en_us" class="grommetux-anchor"><span class="title_div">NonStop Server for Java 4.0 API and Reference</span></a>

#doc = "emr_na-c02124122"
doc = 'https://support.hpe.com/hpsc/doc/public/display?docLocale=en_US&docId=emr_na-c02123501'

profile = Selenium::WebDriver::Firefox::Profile.new

profile['browser.download.dir'] = "/data"
profile['browser.download.folderList'] = 2
profile['browser.helperApps.neverAsk.saveToDisk'] = "application/pdf"
## ##  "text/plain, application/pdf, application/zip"
profile['pdfjs.disabled'] = true
profile['pdfjs.enabledCache.state'] = false     # 
#profile['browser.download.useDownloadDir'] = true
#profile['plugin.scan.plid.all']        = false
#profile['plugin.scan.Acrobat']         = '99.0'
#profile['plugin.disable_full_page_plugin_for_types'] = 'application/pdf'

caps = Selenium::WebDriver::Remote::Capabilities.firefox(firefox_profile: profile)
client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 60 # sec
host = ENV['SELENIUM_SERVER']
driver = Selenium::WebDriver.for :remote, url: "http://#{host}/wd/hub", 
                             desired_capabilities: caps, http_client: client
puts 'window title=' + driver.title

#driver.navigate.to doc
driver.get('http://static.mozilla.com/moco/en-US/pdf/mozilla_privacypolicy.pdf')
#driver.get doc
puts 'navigate complete!'
sleep(10)
puts 'sleeped 10 sec'
sleep(10)
puts 'sleeped 20 sec'
sleep(10)
puts 'sleeped 30 sec'
sleep(10)
puts 'sleeped 40 sec'
#OUT_FILE = '/data/aaa.txt'
#File.open(OUT_FILE,"w").puts(driver.page_source)


#wait = Selenium::WebDriver::Wait.new(timeout: 120)
driver.quit

