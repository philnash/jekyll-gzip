# frozen_string_literal: true

module Jekyll
  module Gzip
    DEFAULT_CONFIG = {
      'extensions' => [
        '.html',
        '.css',
        '.js',
        '.json',
        '.jsonld',
        '.txt',
        '.ttf',
        '.atom',
        '.stl',
        '.xml',
        '.svg',
        '.eot'
      ].freeze,
      'replace_files' => false
    }.freeze
  end
end
