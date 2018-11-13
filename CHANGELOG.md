# Changelog

## Ongoing [☰](https://github.com/philnash/jekyll-gzip/compare/v1.1.0...master)

### Added

* Adds frozen string literal comments
* Tries to hook into Jekyll::Assets if available

### Changed

* Uses built in `Jekyll.env` instead of `ENV["JEKYLL_ENV"]`
* Changes `Jekyll::Gzip::Compressor` to a module and implements a `compress_directory` method

## 1.1.0 (2018-01-03) [☰](https://github.com/philnash/jekyll-gzip/compare/v1.0.0...v1.1.0)

### Changed

* Only run the post write hook when the environment variable `JEKYLL_ENV` is `production`

## 1.0.0 (2018-01-01) [☰](https://github.com/philnash/jekyll-gzip/commits/v1.0.0)

### Added

* Methods to Gzip compress text files throughout a Jekyll site
* Site post write hook to trigger gzip compression
