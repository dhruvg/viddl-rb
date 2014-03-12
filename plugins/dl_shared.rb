require 'open-uri'

# Basically, we expect these links should point to the actual file to begin with.
class DlShared < PluginBase
  # this will be called by the main app to check whether this plugin is responsible for the url passed
  def self.matches_provider?(url)
    url.include?("dl.shared.com")
  end

  def self.get_urls_and_filenames(url, options = {})
    raise CannotMakeFileNameError, "Must provide an id." if options[:id].nil?
    file_name = options[:id].to_s + ".mp3"
    [{:url => url, :name => file_name}]
  end
end