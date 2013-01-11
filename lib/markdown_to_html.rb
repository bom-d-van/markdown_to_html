require "version"
require 'erb'
require 'redcarpet'
require 'pygments'

module MarkdownToHtml
  class HTMLWithPygments < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants

    def block_code(code, language)
      options = { :encoding => 'utf-8'}
      options[:lexer] = language unless language.nil? 
      Pygments.highlight(code, options)
    end
  end
  
  class Renderer
    def initialize(markdown_file, html_file = nil)
      markdown = Redcarpet::Markdown.new(HTMLWithPygments,
                                         :fenced_code_blocks => true,
                                         :no_intra_emphasis => true)

      article = markdown.render(File.new(markdown_file).read)

      html_file = "#{File.basename(markdown_file, File.extname(markdown_file))}.html" if html_file.nil?

      File.open(html_file, 'w') do |html|
        template = File.new(File.dirname(__FILE__) + '/markdown_to_html/template.html.erb').read

        html << ERB.new(template).result(binding)
      end
    end
  end
end
