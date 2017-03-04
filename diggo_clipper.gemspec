Gem::Specification.new do |spec|
	spec.name                  = "diggo_clipper"
	spec.version               = "0.0.2"
	spec.date                  = "2017-03-01"
	spec.summary               = "Diggo Clipper"
	spec.description           = "A tool to clip the web page preserving Diggo annotations and upload it to OneNote"
	spec.authors               = ["bedew"]
	spec.email                 = "sunhe1007@126.com"

  # TODO
	spec.files                 = Dir["lib/**/*.rb"] + Dir["lib/**/.gitkeep"] + Dir["bin/*"]
	spec.files.reject! do |filename|
		filename.include? "config.yml"
	end
	spec.homepage              = "https://bidiu.github.io"
	spec.license               = "MIT"

  # TODO
	spec.add_runtime_dependency "selenium-webdriver", ["= 3.0.5"]
	spec.add_runtime_dependency "json", ["= 1.8.3"]
	spec.add_runtime_dependency "http", ["= 2.2.1"]

	spec.executables << "clipper"
end
