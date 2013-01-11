$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib/markdown_to_html')

require File.dirname(__FILE__) + '/../lib/markdown_to_html.rb'

MarkdownToHtml::Renderer.new 'index.md'

