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
      Jekyll::Gzip::Compressor.compress_file(file_name, extensions: ['.html'])
      expect(File.exist?("#{file_name}.gz")).to be true
    end

    it "doesn't create a gzip file if the extension is not present" do
      file_name = dest_dir("index.html")
      Jekyll::Gzip::Compressor.compress_file(file_name)
      expect(File.exist?("#{file_name}.gz")).to be false
    end

    it "compresses the content of the file in the gzip file" do
      file_name = dest_dir("index.html")
      Jekyll::Gzip::Compressor.compress_file(file_name, extensions: ['.html'])
      content = File.read(file_name)
      Zlib::GzipReader.open("#{file_name}.gz") {|gz|
        expect(gz.read).to eq(content)
      }
    end

    it "doesn't compress non text files" do
      file_name = dest_dir("images/test.png")
      Jekyll::Gzip::Compressor.compress_file(file_name, extensions: ['.html'])
      expect(File.exist?("#{file_name}.gz")).to be false
    end

    it "replaces the file if the settings say so" do
      file_name = dest_dir("index.html")
      original_file_size = File.size(file_name)
      content = File.read(file_name)
      Jekyll::Gzip::Compressor.compress_file(file_name, extensions: ['.html'], replace_file: true)
      expect(File.exist?("#{file_name}")).to be true
      expect(File.exist?("#{file_name}.gz")).to be false
      expect(File.size(file_name)).to be < original_file_size
      Zlib::GzipReader.open("#{file_name}") {|gz|
        expect(gz.read).to eq(content)
      }
    end
  end

  describe "given a Jekyll site" do
    let(:files) {
      [
        dest_dir("index.html"),
        dest_dir("css/main.css"),
        dest_dir("about/index.html"),
        dest_dir("jekyll/update/2018/01/01/welcome-to-jekyll.html"),
        dest_dir("feed.xml")
      ]
    }
    it "compresses all files in the site" do
      Jekyll::Gzip::Compressor.compress_site(site)

      files.each do |file_name|
        expect(File.exist?("#{file_name}.gz")).to be true
      end
    end

    it "replaces the files if the settings say so" do
      original_stats = files.inject({}) { |hash, file|
        hash[file] = {size: File.size(file), content: File.read(file)}
        hash
      }

      site.config['gzip'] ||= {}
      site.config['gzip']['replace_files'] = true
      Jekyll::Gzip::Compressor.compress_site(site)

      files.each { |file|
        expect(File.exist?("#{file}")).to be true
        expect(File.exist?("#{file}.gz")).to be false
        expect(File.size(file)).to be < original_stats[file][:size]
        Zlib::GzipReader.open("#{file}") {|gz|
          expect(gz.read).to eq(original_stats[file][:content])
        }
      }
    end


    it "doesn't compress the files again if they are already compressed and haven't changed" do
      Jekyll::Gzip::Compressor.compress_site(site)

      allow(Zlib::GzipWriter).to receive(:open)

      Jekyll::Gzip::Compressor.compress_site(site)
      expect(Zlib::GzipWriter).not_to have_received(:open)
    end

    it "does compress files that change between compressions" do
      Jekyll::Gzip::Compressor.compress_site(site)

      allow(Zlib::GzipWriter).to receive(:open).and_call_original

      FileUtils.touch(dest_dir("about/index.html"), mtime: Time.now + 1)
      Jekyll::Gzip::Compressor.compress_site(site)
      expect(Zlib::GzipWriter).to have_received(:open).once
    end

    it "doesn't recompress files when in replacement mode" do
      site.config['gzip'] ||= {}
      site.config['gzip']['replace_files'] = true
      Jekyll::Gzip::Compressor.compress_site(site)

      allow(Zlib::GzipWriter).to receive(:open)

      Jekyll::Gzip::Compressor.compress_site(site)
      expect(Zlib::GzipWriter).not_to have_received(:open)
    end
  end

  describe "given a destination directory" do
    let(:files) {[
      dest_dir("index.html"),
      dest_dir("css/main.css"),
      dest_dir("about/index.html"),
      dest_dir("jekyll/update/2018/01/01/welcome-to-jekyll.html"),
      dest_dir("feed.xml")
    ]}

    it "compresses all the text files in the directory" do
      Jekyll::Gzip::Compressor.compress_directory(dest_dir, site)

      files.each do |file_name|
        expect(File.exist?("#{file_name}.gz")).to be true
      end
    end

    it "replaces the files if the settings say so" do
      original_stats = files.inject({}) { |hash, file|
        hash[file] = {size: File.size(file), content: File.read(file)}
        hash
      }

      site.config['gzip'] ||= {}
      site.config['gzip']['replace_files'] = true
      Jekyll::Gzip::Compressor.compress_directory(dest_dir, site)

      files.each { |file|
        expect(File.exist?("#{file}")).to be true
        expect(File.exist?("#{file}.gz")).to be false
        expect(File.size(file)).to be < original_stats[file][:size]
        Zlib::GzipReader.open("#{file}") {|gz|
          expect(gz.read).to eq(original_stats[file][:content])
        }
      }
    end


    it "doesn't compress the files again if they are already compressed and haven't changed" do
      Jekyll::Gzip::Compressor.compress_directory(dest_dir, site)

      allow(Zlib::GzipWriter).to receive(:open)

      Jekyll::Gzip::Compressor.compress_directory(dest_dir, site)
      expect(Zlib::GzipWriter).not_to have_received(:open)
    end

    it "does compress files that change between compressions" do
      Jekyll::Gzip::Compressor.compress_directory(dest_dir, site)
      allow(Zlib::GzipWriter).to receive(:open).and_call_original

      FileUtils.touch(dest_dir("about/index.html"), mtime: Time.now + 1)
      Jekyll::Gzip::Compressor.compress_directory(dest_dir, site)
      expect(Zlib::GzipWriter).to have_received(:open).once
    end

    it "doesn't recompress files when in replacement mode" do
      site.config['gzip'] ||= {}
      site.config['gzip']['replace_files'] = true
      Jekyll::Gzip::Compressor.compress_directory(dest_dir, site)

      allow(Zlib::GzipWriter).to receive(:open)

      Jekyll::Gzip::Compressor.compress_directory(dest_dir, site)
      expect(Zlib::GzipWriter).not_to have_received(:open)
    end
  end
end