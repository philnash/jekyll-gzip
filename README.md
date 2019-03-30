# Jekyll::Gzip

Generate gzipped assets and files for your Jekyll site at build time.

[![Gem Version](https://badge.fury.io/rb/jekyll-gzip.svg)](https://rubygems.org/gems/jekyll-gzip) [![Build Status](https://travis-ci.org/philnash/jekyll-gzip.svg?branch=master)](https://travis-ci.org/philnash/jekyll-gzip) [![Maintainability](https://api.codeclimate.com/v1/badges/895369c1c7a17f879b00/maintainability)](https://codeclimate.com/github/philnash/jekyll-gzip/maintainability) [![Inline docs](https://inch-ci.org/github/philnash/jekyll-gzip.svg?branch=master)](https://inch-ci.org/github/philnash/jekyll-gzip)

[API docs](http://www.rubydoc.info/gems/jekyll-gzip/) | [GitHub repo](https://github.com/philnash/jekyll-gzip)

## Why?

Performance in web applications is important. You know that, which is why you have created a static site using Jekyll. But you want a bit more performance. You're serving your assets and files gzipped, but you're making your webserver do it?

Why not just generate those gzip files at build time? And with the maximum compression too?

`Jekyll::Gzip` does just that. Add the gem to your Jekyll application and when you build your site it will generate gzip files for all text based files (HTML, CSS, JavaScript, etc).

### Want even more compression?

Zlib's gzipping capabilities don't quite squeeze all the compression out of our files that we could want. If you want a slower but better compression algorithm, check out [Jekyll::Zopfli](https://github.com/philnash/jekyll-zopfli).

Zopfli is about the best compression we can get out of the gzip format, but there's more! [Brotli](https://en.wikipedia.org/wiki/Brotli) is a relatively new compression format that is now [supported by many browsers](https://caniuse.com/#search=brotli) and can produce even smaller files. You can use brotli compression alongside gzip in your Sinatra app with [`Jekyll::Brotli`](http://github.com/philnash/jekyll-brotli).

## Installation

Add `Jekyll::Gzip` to your application's dependencies:

```ruby
group :jekyll_plugins do
  gem 'jekyll-gzip'
end
```

And then execute:

```
bundle install
```

Then add the plugin to the `plugins` key in your `_config.yml`

```yml
plugins:
  - jekyll-gzip
```

## Usage

Once you have the gem installed, build your Jekyll site in production mode. On Mac/Linux you can run

```bash
JEKYLL_ENV=production bundle exec jekyll build
```

On Windows, set the `JEKYLL_ENV` environment variable to `"production"`. Check out [this blog post on setting environment variables on Windows](https://www.twilio.com/blog/2017/01/how-to-set-environment-variables.html). Then run:

```bash
bundle exec jekyll build
```

In your destination directory (`_site` by default) you will find gzipped versions of all your text files.

`Jekyll::Gzip` only runs when the environment variable `JEKYLL_ENV` is set to `production` as dealing with gzipping files is unnecessary in development mode and just slows down the site build.

### Configuration

#### Extensions

By default, `Jekyll::Gzip` will compress all files with the following extensions:

- '.html'
- '.css'
- '.js'
- '.txt'
- '.ttf'
- '.atom'
- '.stl'
- '.xml'
- '.svg'
- '.eot'

You can supply your own extensions by adding a `gzip` key to your site's `_config.yml` listing the extensions that you want to compress. For example to only compress HTML, CSS and JavaScript files, add the following to `_config.yml`:

```yml
gzip:
  extensions:
    - '.html'
    - '.css'
    - '.js
```

#### Replacing the original file

If you host your Jekyll site on AWS S3 you can take advantage of `Jekyll::Gzip` for compressing the whole site. The only difference is that you need to replace the uncompressed file with the gzipped file (that is, without a `.gz` extension). To enable this in `Jekyll::Gzip` turn the `replace_files` setting to `true`.

```yml
gzip:
  replace_files: true
```

### Serving pre-compiled gzip files

You will likely need to adjust your web server config to serve these precomputed gzip files. See below for common server configurations:

#### nginx

For nginx, you need to turn on the [`gzip_static` module](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html). Add the following in the relevant `http`, `server` or `location` block:

```
gzip_static on;
```

The `ngx_http_gzip_static_module` module is not built by default, so you may need to enable using the `--with-http_gzip_static_module` configuration parameter.

#### Apache

In either a `<Directory>` section in your Apache config or in an `.htaccess` file, add the following:

```
AddEncoding gzip .gz
RewriteCond %{HTTP:Accept-encoding} gzip
RewriteCond %{REQUEST_FILENAME}.gz -f
RewriteRule ^(.*)$ $1.gz [QSA,L]
```

#### Other web servers

TODO: instructions for other web servers like HAProxy, h2o etc.

Do you know how to do this for a different server? Please open a [pull request](https://github.com/philnash/jekyll-gzip/pulls) or an [issue](https://github.com/philnash/jekyll-gzip/issues) with the details!

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/philnash/jekyll-gzip. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Gzip project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/philnash/jekyll-gzip/blob/master/CODE_OF_CONDUCT.md).
