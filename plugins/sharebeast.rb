require 'open-uri'

class Sharebeast < PluginBase
  # this will be called by the main app to check whether this plugin is responsible for the url passed
  def self.matches_provider?(url)
    url.include?("sharebeast.com")
  end

  def self.get_urls_and_filenames(url, options = {})
    raise CannotMakeFileNameError, "Must provide an id." if options[:id].nil?
    doc = Nokogiri::HTML(open(get_http_url(url)))
    download_button = doc.css("#mp3player audio source")[0]
    raise CouldNotDownloadVideoError, "No download button found." if download_button.nil?

    download_url = download_button.attributes["src"].value.to_s
    file_name = options[:id].to_s + ".mp3"
    [{:url => download_url, :name => file_name}]
  end
end