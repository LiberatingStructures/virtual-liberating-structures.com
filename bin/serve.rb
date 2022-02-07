#!/usr/bin/env ruby

require 'webrick'

s = WEBrick::HTTPServer.new(:Port => 9090, :DocumentRoot => File.dirname(__FILE__) + "/../docs/")
trap('INT') { s.shutdown }
s.start

