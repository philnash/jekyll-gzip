# frozen_string_literal: true

require "jekyll/gzip/version"
require "jekyll/gzip/compressor"
require "pathname"

module Jekyll
  module Gzip
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  if Jekyll.env == "production"
    Jekyll::Gzip::Compressor.compress_site(site)
  end
end

begin
  require "jekyll-assets"

  Jekyll::Assets::Hook.register :env, :after_write do |env|
    if Jekyll.env == "production"
      path = Pathname.new("#{env.jekyll.config["destination"]}#{env.prefix_url}")
      Jekyll::Gzip::Compressor.compress_directory(path)
    end
  end
rescue LoadError
  # The Jekyll site doesn't use Jekyll::Assets, so no need to compress those
  # files.
end