require 'open-uri'

class GotInstrumentals < PluginBase
  # this will be called by the main app to check whether this plugin is responsible for the url passed
  def self.matches_provider?(url)
    url.include?("gotinstrumentals.com")
  end

  def self.get_urls_and_filenames(url, options = {})
    raise CannotMakeFileNameError, "Must provide an id." if options[:id].nil?
    doc = Nokogiri::HTML(open(get_http_url(url)))
    download_button = doc.at("a.dlbtnsong1")
    raise CouldNotDownloadVideoError, "No download button found." if download_button.nil?

    download_url = "http://gotinstrumentals.com#{download_button.attributes["href"].value.to_s}"
    file_name = options[:id].to_s + ".mp3"
    [{:url => download_url, :name => file_name}]
  end
end