require 'open-uri'

class Hipstrumentals < PluginBase
  # this will be called by the main app to check whether this plugin is responsible for the url passed
  def self.matches_provider?(url)
    url.include?("hipstrumentals.com")
  end

  def self.get_urls_and_filenames(url, options = {})
    raise CannotMakeFileNameError, "Must provide an id." if options[:id].nil?
    doc = Nokogiri::HTML(open(get_http_url(url)))
    download_link = doc.css(".entry a")[0].attributes["href"].value
    raise CouldNotDownloadVideoError, "No download link found." if download_link.nil?

    file_name = options[:id].to_s + ".mp3"
    [{:url => download_link, :name => file_name}]
  end
end