# Changelog

## Ongoing [☰](https://github.com/philnash/jekyll-gzip/compare/v2.4.1...master)

...

## 2.4.2 (2020-01-30) [☰](https://github.com/philnash/jekyll-gzip/compare/v2.4.1...v2.4.2)

### Changed

- Fixes the path handed to `Dir.glob` by using `File.join` instead of string concatenation


## 2.4.1 (2019-12-31) [☰](https://github.com/philnash/jekyll-gzip/compare/v2.4.0...v2.4.1)

### Changed

- Extends regeneration logic to files compressed by directory, not just site.
- Fixes tests that were just wrong for quite a long time.

## 2.4.0 (2019-12-31) [☰](https://github.com/philnash/jekyll-gzip/compare/v2.3.0...v2.4.0)

### Changed

- Doesn't regenerate files that haven't changed in incremental builds (thanks [@fauno](https://github.com/fauno))

## 2.3.0 (2019-08-26) [☰](https://github.com/philnash/jekyll-gzip/compare/v2.1.1...v2.3.0)

### Changed

- Opens up version support for Jekyll 4 (thanks [@thedanbob](https://github.com/thedanbob))

## 2.1.1 (2019-03-30) [☰](https://github.com/philnash/jekyll-gzip/compare/v2.1.0...v2.1.1)

### Fixed

- Replacing files with gzipped version wasn't working, fixed thanks to [k0nserv](https://github.com/k0nserv) in #6.

## 2.1.0 (2019-03-30) [☰](https://github.com/philnash/jekyll-gzip/compare/v2.0.0...v2.1.0)

### Added

- Adds setting to replace original files with gzipped for serving from AWS S3

## 2.0.0 (2018-11-24) [☰](https://github.com/philnash/jekyll-gzip/compare/v1.1.0...v2.0.0)

### Added

- Adds frozen string literal comments
- Tries to hook into Jekyll::Assets if available

### Changed

- Uses built in `Jekyll.env` instead of `ENV["JEKYLL_ENV"]`
- Changes `Jekyll::Gzip::Compressor` to a module and implements a `compress_directory` method
- Moves Jekyll::Gzip::ZIPPABLE_EXTENSIONS into plugin config that can overwritten in the site config

## 1.1.0 (2018-01-03) [☰](https://github.com/philnash/jekyll-gzip/compare/v1.0.0...v1.1.0)

### Changed

- Only run the post write hook when the environment variable `JEKYLL_ENV` is `production`

## 1.0.0 (2018-01-01) [☰](https://github.com/philnash/jekyll-gzip/commits/v1.0.0)

### Added

- Methods to Gzip compress text files throughout a Jekyll site
- Site post write hook to trigger gzip compression
