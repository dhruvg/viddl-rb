module ViddlRb

  class PluginBase

    #this exception is raised by the plugins when it was not 
    #possible to download the video for some reason.
    class CouldNotDownloadVideoError < StandardError; end

    #this exception is raised by the plugins when no id is provided
    #and no fallback option is implemented for generating the file name
    class CannotMakeFileNameError < StandardError; end

    #some static stuff
    class << self
      attr_accessor :io
      attr_reader   :registered_plugins
    end

    #all calls to #puts, #print and #p from any plugin instance will be redirected to this object 
    @io = $stdout
    @registered_plugins = []

    #if you inherit from this class, the child gets added to the "registered plugins" array
    def self.inherited(child)
      PluginBase.registered_plugins << child
    end

    #takes a string a returns a new string that is file name safe on Windows and Unix systems.
    def self.make_filename_safe(string)
      safe = UtilityHelper.windows? ? string.gsub(/[:*?"<>^|\/\\]/, "_") : string.gsub(/[\/\\0]/, "_")
      safe.squeeze("_")
    end

    #the following methods redirects the Kernel printing methods (except #p) to the
    #PluginBase IO object. this is because sometimes we want plugins to
    #write to something else than $stdout

    def self.puts(*objects)
      PluginBase.io.puts(*objects)
      nil
    end

    def self.print(*objects)
      PluginBase.io.print(*objects)
      nil
    end

    def self.putc(int)
      PluginBase.io.putc(int)
      nil
    end

    def self.printf(string, *objects)
      if string.is_a?(IO) || string.is_a?(StringIO)
        super(string, *objects)  # so we don't redirect the printf that prints to a separate IO object
      else
        PluginBase.io.printf(string, *objects)
      end
      nil
    end

    def self.get_http_url(url)
      url.sub(/https?:\/\//, "http:\/\/")
    end

    def self.get_https_url(url)
      url.sub(/https?:\/\//, "https:\/\/")
    end
  end
end
