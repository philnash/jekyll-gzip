require "jekyll/gzip/version"
require "jekyll/gzip/compressor"

module Jekyll
  module Gzip
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll::Gzip::Compressor.new(site).compress
end