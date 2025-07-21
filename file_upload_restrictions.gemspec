# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_upload_restrictions/version'

Gem::Specification.new do |spec|
  spec.name          = "file_upload_restrictions"
  spec.version       = FileUploadRestrictions::Version
  spec.authors       = ["Scott Phillips"]
  spec.email         = ["scott.phillips@atomicjolt.com"]

  spec.summary       = "Canvas File Upload Restrictions"
  spec.description   = "Canvas File Upload Restrictions"
  spec.homepage      = "https://atomicjolt.com"

  spec.files = Dir["{app,lib}/**/*"]
end
