module Jekyll
  module Gzip
    DEFAULT_CONFIG = {
      'extensions' => [
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
    }.freeze
  end
end