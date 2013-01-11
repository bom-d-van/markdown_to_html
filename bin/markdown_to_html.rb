#! /usr/bin/env ruby
require 'rubygems'
require 'markdown_to_html'

MarkdownToHtml::Renderer.new(ARGV[0])