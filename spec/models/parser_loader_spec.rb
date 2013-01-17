require "spec_helper"

describe ParserLoader do

  class Europeana; end

  let(:parser) { Parser.build(strategy: "json", name: "europeana.rb", data: "class Europeana \n end") }
  let(:loader) { ParserLoader.new(parser) }
  
  describe "#path" do
    it "builds a absolute path to the temp file" do
      loader.path.should eq "#{Rails.root.to_s}/tmp/parsers/json/europeana.rb"
    end

    it "memoizes the path" do
      parser.should_receive(:name).once
      loader.path
      loader.path
    end
  end

  describe "#create_tempfile" do
    it "creates a new tempfile with the path" do
      loader.create_tempfile
      File.read(loader.path).should eq "class Europeana \n end"
    end
  end

  describe "#parser_class" do
    it "returns the class singleton" do
      loader.parser_class.should eq Europeana
    end
  end

  describe "#load_parser" do
    it "creates the tempfile" do
      loader.should_receive(:create_tempfile)
      loader.load_parser
    end

    it "loads the file" do
      loader.should_receive(:load).with(loader.path)
      loader.load_parser.should be_true
    end

    it "rescues from any error" do
      loader.stub(:load).and_raise(SyntaxError.new("Error while loading"))
      loader.load_parser.should be_false
      loader.syntax_error.should eq "Error while loading"
    end
  end

  describe "loaded?" do
    it "loads the parser file" do
      loader.should_receive(:load_parser)
      loader.loaded?
    end

    it "returns the @loaded value" do
      loader.instance_variable_set("@loaded", true)
      loader.loaded?.should be_true
    end
  end
end