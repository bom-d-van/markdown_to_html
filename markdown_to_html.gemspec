# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'markdown_to_html/version'

Gem::Specification.new do |gem|
  gem.name          = "markdown_to_html"
  gem.version       = MarkdownToHtml::VERSION
  gem.authors       = ["bom.d.van"]
  gem.email         = ["bom.d.van@gmail.com"]
  gem.description   = %q{render a github-flavored markdown file into a beautiful html document}
  gem.summary       = %q{With the funtionality of rendering github flavored markdown file into a html file, markdown_to_html also offers user a good-looking html style, making reading rendered html document an enjoyment.}
  gem.homepage      = ""

  gem.add_runtime_dependency 'redcarpet', '1.17.2'
  gem.add_runtime_dependency 'pygments.rb'
  gem.add_runtime_dependency 'nokogiri'
  
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
