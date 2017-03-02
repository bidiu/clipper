module DiggoClipper
  # Javasciprt snippet loader
  class Js
    JS_DIR = File.join(GEM_LIB_DIR, GEM_NAME, "js")

    def self.[](snippet_name)
      load snippet_name
    end

    def self.load(snippet_name)
      snippet_name = snippet_name.to_s if snippet_name.is_a? Symbol
      File.read(File.join(JS_DIR, snippet_name + ".js"))
    end

    private_class_method :new
  end
end
