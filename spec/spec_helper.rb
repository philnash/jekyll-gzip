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
    "source"      => source_dir,
    "destination" => dest_dir
  }.freeze

  def site_config
    YAML.load(File.read(source_dir('_config.yml')))
  end

  def make_site
    config = Jekyll::Utils.deep_merge_hashes(CONFIG_DEFAULTS, site_config)
    site_config = Jekyll.configuration(config)
    Jekyll::Site.new(site_config)
  end
end