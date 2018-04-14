require 'selenium-webdriver'

def logOut(logFile,logText)
  logFile.puts(logText)
  puts(logText)
end

NONSTOP_JDOCS_URL = 'http://www.hpe.com/info/nonstop-jdocs'
#NONSTOP_DOCVIEW_URL = 'https://support.hpe.com/hpsc/doc/public/display?docLocale=en_US&docId=emr_na-c05274797'
NONSTOP_DOCVIEW_URL = 'https://support.hpe.com/hpsc/doc/public/display?docLocale=en_US&docId='
DOCS_TEXT      = '/data/docs.txt'
DOWNLOAD_DIR   = '/data/download'
DOWNLOAD_FILE  = "#{DOWNLOAD_DIR}/Download"   # .pdf or .zip
LOG_FILE       = '/data/getDoc.log'
SLEEP_INTERVAL = 1
RETRY_MAX      = 120
FORCE_UPDATE   = false    # すでにファイルが存在する場合は、キャンセル


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


logFile = File.open(LOG_FILE,"w")
File.open(DOCS_TEXT).each_line{|l|
  next unless(l =~ /^listresult_(emr_na-(\S)\S+)\s+\((.+)\)$/)
  doc_id    = $1
  doc_title = $3
  doc_type  = ($2 == 'a') ? '.zip' : '.pdf'

  download_url  = NONSTOP_DOCVIEW_URL + doc_id
  download_file_ptn = [DOWNLOAD_FILE + "*.zip",DOWNLOAD_FILE + "*.pdf"]
  save_file     = DOWNLOAD_DIR + "/" + doc_id 
  save_file_ptn = [ DOWNLOAD_DIR + "/" + doc_id  + "*.zip",DOWNLOAD_DIR + "/" + doc_id  + "*.pdf"]

  logOut(logFile,"DownLoad Start #{doc_title}(#{doc_id})")
  if(Dir.glob(save_file_ptn).size > 0)then
    logOut(logFile," (ERR)Already Downloaded(#{doc_id}(#{doc_title}))")
    logOut(logFile,"       file=#{Dir.glob(save_file_ptn)[0]}!!!")
    next
  end
  driver.navigate.to download_url

  # Check Download Complete
  #  navigate.toが完了しても、ダウンロードは完了していない。ダウンロードは非同期で実施される。
  #  chromeでは、一旦'ダウンロードファイル名.crdownload'というファイル名でダウンロードを実施。
  #  ダウンロードが完了したら、本来の'ダウンロードファイル名'にRenameする。
  #  このため、本来のファイル名のファイルが存在するかチェックする必要がある
  #
  #  NonStopのマニュアルは、基本、Download.xxx(pdf or zip)になるが、一部違うファイル名で
  #  ダウンロードされる場合がある(emr_na-c03466757-1.pdfなど、doc-idの後ろに、連番が付く？)
  #  以下ロジックでは、それに対応できていない。RETRY_MAXまで繰り返したあと、エラーメッセージを
  #  出すが、ダウンロード自体は正常に完了している。
  #  Download.xxxだけではなく、docid-数値.xxxもチェックした方が良い
  old_file_size = 0
  retry_count = 0
  while(1) do
    sleep(SLEEP_INTERVAL)
    unless(Dir.glob(save_file_ptn).size > 0) or (Dir.glob(download_file_ptn).size > 0)then
      retry_count = retry_count + 1
      logOut(logFile," File Not Exist.Retry!(#{retry_count})")
      if(retry_count > RETRY_MAX ) then
        break
      end
      next
    end

    logOut(logFile, "DownLoad Complete!")
    break
  end

  #file Rename
  if(retry_count > RETRY_MAX)then
    logOut(logFile," (ERR)Request file not exists??? skip download(#{doc_id}(#{doc_title}))!!!")
    next
  end

  if(Dir.glob(download_file_ptn).size >0)then
    download_file = Dir.glob(download_file_ptn)[0]
    save_file = save_file + File.extname(download_file)
    File.rename(download_file,save_file) 
  elsif(Dir.glob(save_file_ptn).size >0) then
    save_file = Dir.glob(save_file_ptn)[0]
  end

  doc_file = DOWNLOAD_DIR + "/" + doc_title.gsub(/[ ,:\/]/,"_") + File.extname(save_file)
  File.rename(save_file, doc_file)

}
                            

driver.quit

