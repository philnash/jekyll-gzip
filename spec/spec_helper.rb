# frozen_string_literal: true

require "yaml"
require "bundler/setup"
require "jekyll"
require "simplecov"

SimpleCov.start do
  add_filter "spec"
end

Jekyll.logger.log_level = :error

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  SOURCE_DIR = File.expand_path("../fixtures", __FILE__)
  DEST_DIR   = File.expand_path("../dest", __FILE__)

  def source_dir(*files)
    File.join(SOURCE_DIR, *files)
  end

  def dest_dir(*files)
    File.join(DEST_DIR, *files)
  end

  CONFIG_DEFAULTS = {
    "source"            => source_dir,
    "destination"       => dest_dir,
    "title"             => "Your awesome title",
    "email"             => "your-email@domain.com",
    "description"       => "A description",
    "baseurl"           => "",
    "url"               => "http://yourdomain.com",
    "twitter_username"  => "jekyllrb",
    "github_username"   => "jekyll",
    "markdown"          => "kramdown"
  }.freeze

  def make_site(opts={})
    config = Jekyll::Utils.deep_merge_hashes(opts, CONFIG_DEFAULTS)
    site_config = Jekyll.configuration(config)
    Jekyll::Site.new(site_config)
  end
end