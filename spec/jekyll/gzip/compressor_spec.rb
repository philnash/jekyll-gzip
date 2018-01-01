require "zlib"
require "./lib/jekyll/gzip/compressor"

RSpec.describe Jekyll::Gzip::Compressor do
  let(:site) { make_site }

  it "is initialized with a Jekyll site" do
    compressor = Jekyll::Gzip::Compressor.new(site)
    expect(compressor.site).to eq(site)
  end

  describe "given a file name" do
    before(:each) { site.process }
    after(:each) { FileUtils.rm_r(dest_dir) }

    let(:compressor) { Jekyll::Gzip::Compressor.new(site) }

    it "creates a gzip file" do
      file_name = dest_dir("index.html")
      compressor.compress_file(file_name)
      expect(File.exist?("#{file_name}.gz")).to be true
    end

    it "compresses the content of the file in the gzip file" do
      file_name = dest_dir("index.html")
      compressor.compress_file(file_name)
      content = File.read(file_name)
      Zlib::GzipReader.open("#{file_name}.gz") {|gz|
        expect(gz.read).to eq(content)
      }
    end

    it "doesn't compress non text files" do
      file_name = dest_dir("images/test.png")
      compressor.compress_file(file_name)
      expect(File.exist?("#{file_name}.gz")).to be false
    end

    it "compresses all files in the site" do
      compressor.compress
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