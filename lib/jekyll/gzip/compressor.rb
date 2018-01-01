require "zlib"

module Jekyll
  module Gzip
    class Compressor
      ZIPPABLE_EXTENSIONS = [
        '.html',
        '.css',
        '.js',
        '.txt',
        '.ttf',
        '.atom',
        '.stl',
        '.xml',
        '.svg',
        '.eot'
      ]

      attr_reader :site

      def initialize(site)
        @site = site
      end

      def compress_file(file_name)
        return unless ZIPPABLE_EXTENSIONS.include?(File.extname(file_name))
        zipped = "#{file_name}.gz"
        Zlib::GzipWriter.open(zipped, Zlib::BEST_COMPRESSION) do |gz|
          gz.mtime = File.mtime(file_name)
          gz.orig_name = file_name
          gz.write IO.binread(file_name)
        end
      end

      def compress(site)
        site.each_site_file do |file|
          compress_file(file.destination(site.dest))
        end
      end
    end
  end
end 