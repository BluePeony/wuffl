Gem::Specification.new do |s|
  s.name         = "wuffl"
  s.version      = "1.0.0"
  s.author       = "BluePeony"
  s.email        = "blue.peony2314@gmail.com"
  s.homepage     = "https://github.com/BluePeony/wuffl"
  s.summary      = "image viewer with options to put an image either to the folder 'Selected' or the folder 'Deleted' to preselect them for further use"
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README'))
  s.licenses     = ['MIT']

  s.files         = Dir["{bin,lib}/**/*"] + %w(LICENSE README)
  s.executables   = [ 'wuffl' ]

  s.required_ruby_version = '>=1.9'
  s.add_runtime_dependency 'gtk3'
  s.add_runtime_dependency 'fileutils'
  s.add_runtime_dependency 'fastimage'
  s.add_runtime_dependency 'stringio'
end
