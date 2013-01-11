require_relative "markdown_to_html/version"
gem 'redcarpet', '=1.17.2'
require 'redcarpet'
require 'nokogiri'
require 'pygments'

module MarkdownToHtml
  class Renderer
    def initialize(markdown_file)
      options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
      
      # Redcarpet::Render::HTML.new(options)
      html = Redcarpet.new(File.new(markdown_file).read, *options).to_html
      
      doc = Nokogiri::HTML(html)
      doc.search("//pre[@lang]").each do |pre|
        # pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
        # pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
        pre.replace Pygments.highlight(pre.text.rstrip, :options => { :encoding => 'utf-8' })
      end
      
      # doc.search("//body").first.insert_before default_head
      # puts doc.at('html')
      # doc.add_child default_head
      
      html = File.new 'index.html', 'w'
      html << doc.to_s
      html.close
    end
    
    def default_head
      <<-default_head_str
      <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <title>index</title>
        <style type="text/css" media="screen">
          html {
            overflow-y: visible;
          }
          body {
            margin: auto;
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 14px;
            line-height: 20px;
            color: #333;
            background-color: white;
            overflow: auto;
            width: 80%;
            padding: 25px 0;
          }
          pre {
            display: block;
            padding: 9.5px;
            margin: 0 0 10px;
            font-size: 13px;
            line-height: 20px;
            word-break: break-all;
            word-wrap: break-word;
            white-space: pre;
            white-space: pre-wrap;
            background-color: whiteSmoke;
            border: 1px solid #CCC;
            border: 1px solid rgba(0, 0, 0, 0.15);
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            border-radius: 4px;
          }
          .hll { background-color: #ffffcc }
          .c { color: #408080; font-style: italic } /* Comment */
          .err { border: 1px solid #FF0000 } /* Error */
          .k { color: #008000; font-weight: bold } /* Keyword */
          .o { color: #666666 } /* Operator */
          .cm { color: #408080; font-style: italic } /* Comment.Multiline */
          .cp { color: #BC7A00 } /* Comment.Preproc */
          .c1 { color: #408080; font-style: italic } /* Comment.Single */
          .cs { color: #408080; font-style: italic } /* Comment.Special */
          .gd { color: #A00000 } /* Generic.Deleted */
          .ge { font-style: italic } /* Generic.Emph */
          .gr { color: #FF0000 } /* Generic.Error */
          .gh { color: #000080; font-weight: bold } /* Generic.Heading */
          .gi { color: #00A000 } /* Generic.Inserted */
          .go { color: #808080 } /* Generic.Output */
          .gp { color: #000080; font-weight: bold } /* Generic.Prompt */
          .gs { font-weight: bold } /* Generic.Strong */
          .gu { color: #800080; font-weight: bold } /* Generic.Subheading */
          .gt { color: #0040D0 } /* Generic.Traceback */
          .kc { color: #008000; font-weight: bold } /* Keyword.Constant */
          .kd { color: #008000; font-weight: bold } /* Keyword.Declaration */
          .kn { color: #008000; font-weight: bold } /* Keyword.Namespace */
          .kp { color: #008000 } /* Keyword.Pseudo */
          .kr { color: #008000; font-weight: bold } /* Keyword.Reserved */
          .kt { color: #B00040 } /* Keyword.Type */
          .m { color: #666666 } /* Literal.Number */
          .s { color: #BA2121 } /* Literal.String */
          .na { color: #7D9029 } /* Name.Attribute */
          .nb { color: #008000 } /* Name.Builtin */
          .nc { color: #0000FF; font-weight: bold } /* Name.Class */
          .no { color: #880000 } /* Name.Constant */
          .nd { color: #AA22FF } /* Name.Decorator */
          .ni { color: #999999; font-weight: bold } /* Name.Entity */
          .ne { color: #D2413A; font-weight: bold } /* Name.Exception */
          .nf { color: #0000FF } /* Name.Function */
          .nl { color: #A0A000 } /* Name.Label */
          .nn { color: #0000FF; font-weight: bold } /* Name.Namespace */
          .nt { color: #008000; font-weight: bold } /* Name.Tag */
          .nv { color: #19177C } /* Name.Variable */
          .ow { color: #AA22FF; font-weight: bold } /* Operator.Word */
          .w { color: #bbbbbb } /* Text.Whitespace */
          .mf { color: #666666 } /* Literal.Number.Float */
          .mh { color: #666666 } /* Literal.Number.Hex */
          .mi { color: #666666 } /* Literal.Number.Integer */
          .mo { color: #666666 } /* Literal.Number.Oct */
          .sb { color: #BA2121 } /* Literal.String.Backtick */
          .sc { color: #BA2121 } /* Literal.String.Char */
          .sd { color: #BA2121; font-style: italic } /* Literal.String.Doc */
          .s2 { color: #BA2121 } /* Literal.String.Double */
          .se { color: #BB6622; font-weight: bold } /* Literal.String.Escape */
          .sh { color: #BA2121 } /* Literal.String.Heredoc */
          .si { color: #BB6688; font-weight: bold } /* Literal.String.Interpol */
          .sx { color: #008000 } /* Literal.String.Other */
          .sr { color: #BB6688 } /* Literal.String.Regex */
          .s1 { color: #BA2121 } /* Literal.String.Single */
          .ss { color: #19177C } /* Literal.String.Symbol */
          .bp { color: #008000 } /* Name.Builtin.Pseudo */
          .vc { color: #19177C } /* Name.Variable.Class */
          .vg { color: #19177C } /* Name.Variable.Global */
          .vi { color: #19177C } /* Name.Variable.Instance */
          .il { color: #666666 } /* Literal.Number.Integer.Long */
        </style>
      </head>
      default_head_str
    end
  end
end
