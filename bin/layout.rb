#!/usr/bin/env ruby

require "erb"
require "yaml"
require "pathname"

MenuItem = Struct.new(:path, :file_path, :title, :url)

class Template
  attr_reader :layout_root, :output_path, :menu_items, :template

  def initialize
    @layout_root = Pathname.new(File.dirname(__FILE__)) + ".." + "layout"
    @output_path = Pathname.new(File.dirname(__FILE__)) + ".." + "docs"

    @template = ERB.new(read_file("layout.html.erb"))
    @menu_items = parse_menu
  end

  def parse_menu
    menu_yaml = YAML.load(read_file("menu.yml"))['menu']
    menu_yaml.map do |k, menu_item|
      raise "Paths must commence with /" unless menu_item['path'].start_with?("/")
      MenuItem.new(
        menu_item['path'],
        output_path + ".#{menu_item['path']}",
        menu_item['title'],
        menu_item['url']
      )
    end
  end

  def read_file(file)
    File.read(layout_root + file)
  end

  def generate_all
    puts output_path
    menu_items.each do |menu_item|
      generate(menu_item)
    end
  end

  def generate(menu_item)
    puts "Rendering #{menu_item.title} at #{menu_item.path}"
    puts "D #{menu_item.file_path}"

    menu_item.file_path.mkpath

    index_path = menu_item.file_path + "index.html"

    puts "F #{index_path}"

    data = template.result_with_hash(
      menu_items: menu_items,
      iframe_url: menu_item.url,
      title: menu_item.title
    )

    File.write(index_path, data)
  end
end

require 'pp'
Template.new.generate_all

