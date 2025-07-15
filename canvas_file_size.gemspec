# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'canvas_file_size/version'

Gem::Specification.new do |spec|
  spec.name          = "canvas_file_size"
  spec.version       = CanvasFileSize::Version
  spec.authors       = ["Scott Phillips"]
  spec.email         = ["scott.phillips@atomicjolt.com"]

  spec.summary       = "Canvas File Size Restrictions"
  spec.description   = "Canvas File Size Restrictions"
  spec.homepage      = "https://atomicjolt.com"

  spec.files = Dir["{app,lib}/**/*"]
end
