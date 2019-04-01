# frozen_string_literal: true

require 'jekyll/gzip/config'
require 'zlib'

module Jekyll
  ##
  # The main namespace for +Jekyll::Gzip+. Includes the +Compressor+ module
  # which is used to map over files, either using an instance of +Jekyll::Site+
  # or a directory path, and compress them using Zlib.
  module Gzip
    ##
    # The module that does the compressing using Zlib.
    module Compressor
      ##
      # Takes an instance of +Jekyll::Site+ and maps over the site files,
      # compressing them in the destination directory.
      # @example
      #     site = Jekyll::Site.new(site_config)
      #     Jekyll::Gzip::Compressor.compress_site(site)
      #
      # @param site [Jekyll::Site] A Jekyll::Site object that has generated its
      #   site files ready for compression.
      #
      # @return void
      def self.compress_site(site)
        site.each_site_file do |file|
          compress_file(
            file.destination(site.dest),
            extensions: zippable_extensions(site),
            replace_file: replace_files(site)
          )
        end
      end

      ##
      # Takes a directory path and maps over the files within compressing them
      # in place.
      #
      # @example
      #     Jekyll::Gzip::Compressor.compress_directory("~/blog/_site", site)
      #
      # @param dir [Pathname, String] The path to a directory of files ready for
      #   compression.
      # @param site [Jekyll::Site] An instance of the `Jekyll::Site` used for
      #   config.
      #
      # @return void
      def self.compress_directory(dir, site)
        extensions = zippable_extensions(site).join(',')
        replace_file = replace_files(site)
        files = Dir.glob(dir + "**/*{#{extensions}}")
        files.each { |file| compress_file(file, extensions: extensions, replace_file: replace_file) }
      end

      ##
      # Takes a file name and an array of extensions. If the file name extension
      # matches one of the extensions in the array then the file is loaded and
      # compressed using Zlib, outputting the gzipped file under the name of
      # the original file with an extra .gz extension.
      #
      # @example
      #     Jekyll::Gzip::Compressor.compress_file("~/blog/_site/index.html")
      #
      # @param file_name [String] The file name of the file we want to compress
      # @param extensions [Array<String>] The extensions of files that will be
      #    compressed.
      # @param replace_file [Boolean] Whether the origina file should be
      #    replaced or written alongside the original with a `.gz` extension
      #
      # @return void
      def self.compress_file(file_name, extensions: [], replace_file: false)
        return unless extensions.include?(File.extname(file_name))
        zipped = replace_file ? file_name : "#{file_name}.gz"
        file_content = IO.binread(file_name)
        Zlib::GzipWriter.open(zipped, Zlib::BEST_COMPRESSION) do |gz|
          gz.mtime = File.mtime(file_name)
          gz.orig_name = file_name
          gz.write file_content
        end
      end

      private

      def self.zippable_extensions(site)
        site.config.dig('gzip', 'extensions') || Jekyll::Gzip::DEFAULT_CONFIG['extensions']
      end

      def self.replace_files(site)
        replace_files = site.config.dig('gzip', 'replace_files')
        replace_files.nil? ? Jekyll::Gzip::DEFAULT_CONFIG['replace_files'] : replace_files
      end
    end
  end
end
