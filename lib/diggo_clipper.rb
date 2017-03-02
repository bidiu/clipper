require "selenium-webdriver"
require "http"
require "json"
require "uri"
require "cgi"
require "singleton"

require_relative "diggo_clipper/config/config"
require_relative "diggo_clipper/helper"
require_relative "diggo_clipper/driver"
require_relative "diggo_clipper/authentication"

module DiggoClipper
  GEM_NAME = "diggo_clipper"
  GEM_LIB_DIR = __dir__

  # Diggo Chrome extension
  VENDOR_LIB_NAME = "Diigo-Web-Collector-Capture-and-Annotate_v3.3.50.crx"
end
