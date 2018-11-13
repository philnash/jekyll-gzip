# frozen_string_literal: true

require "zlib"
require "./lib/jekyll/gzip/compressor"

RSpec.describe Jekyll::Gzip::Compressor do
  let(:site) { make_site }
  before(:each) { site.process }
  after(:each) { FileUtils.rm_r(dest_dir) }

  describe "given a file name" do
    it "creates a gzip file" do
      file_name = dest_dir("index.html")
      Jekyll::Gzip::Compressor.compress_file(file_name)
      expect(File.exist?("#{file_name}.gz")).to be true
    end

    it "compresses the content of the file in the gzip file" do
      file_name = dest_dir("index.html")
      Jekyll::Gzip::Compressor.compress_file(file_name)
      content = File.read(file_name)
      Zlib::GzipReader.open("#{file_name}.gz") {|gz|
        expect(gz.read).to eq(content)
      }
    end

    it "doesn't compress non text files" do
      file_name = dest_dir("images/test.png")
      Jekyll::Gzip::Compressor.compress_file(file_name)
      expect(File.exist?("#{file_name}.gz")).to be false
    end
  end

  describe "given a Jekyll site" do
    it "compresses all files in the site" do
      Jekyll::Gzip::Compressor.compress_site(site)
      files = [
        dest_dir("index.html"),
        dest_dir("css/main.css"),
        dest_dir("about/index.html"),
        dest_dir("jekyll/update/2018/01/01/welcome-to-jekyll.htlm"),
        dest_dir("feed.xml")
      ]
      files.each do |file_name|
        expect(File.exist?("#{file_name}.gz"))
      end
    end
  end

  describe "given a destination directory" do
    it "compresses all the text files in the directory" do
      Jekyll::Gzip::Compressor.compress_directory(dest_dir)
      files = [
        dest_dir("index.html"),
        dest_dir("css/main.css"),
        dest_dir("about/index.html"),
        dest_dir("jekyll/update/2018/01/01/welcome-to-jekyll.htlm"),
        dest_dir("feed.xml")
      ]
      files.each do |file_name|
        expect(File.exist?("#{file_name}.gz"))
      end
    end
  end
end