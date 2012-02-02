require "spec_helper"

describe "Vocab::Extractor::Android" do

  before( :each ) do
    @locale = "#{vocab_root}/spec/data/android/locales/strings.xml"
  end

  describe 'extract_current' do

    it "extracts hash of current string translations" do
      actual = Vocab::Extractor::Android.extract_current( @locale )
      actual.should eql( { "app_name"   =>"Kid Mode",
                           "delete"     =>"Delete",
                           "cancel"     =>"Cancel",
                           "app_current"=>"current",
                           "pd_app_name"=>"Parent Dashboard" } )
    end

    it "raises an exception if translation file not specified to extract_current" do
      lambda { Vocab::Extractor::Android.extract_current }.should raise_error
    end

  end

  describe 'extract_previous' do

    before( :each ) do
      Dir.chdir( vocab_root )
    end

    before( :each ) do
      @sha = 'a19f7c5c28c1158792a966c0d2153a04490dd35e'
      Vocab.settings.stub!( :last_translation ).and_return( @sha )
    end

    it "extracts hash of previous string translations" do
      actual = Vocab::Extractor::Android.extract_previous( @locale )
      actual.should eql( { 'app_name'    => 'Kid Mode',
                           'pd_app_name' => 'Parent Dashboard',
                           'app_current' => 'current' } )
    end

    it "raises an exception if translation file not specified to extract_previous" do
      lambda { Vocab::Extractor::Android.extract_previous }.should raise_error
    end

  end

  describe 'write_full' do

    it 'writes the full translation to the correct xml file' do
      hash = { 'foo' => 'bar' }
      Vocab::Extractor::Android.should_receive( :write ).
              with( hash, "#{vocab_root}/strings.full.xml" )
      Vocab::Extractor::Android.write_full( hash )
    end

  end

  describe 'write_diff' do

    it 'writes the diff translation to the correct xml file' do
      hash = { 'foo' => 'bar' }
      Vocab::Extractor::Android.should_receive( :write ).
              with( hash, "#{vocab_root}/strings.diff.xml" )
      Vocab::Extractor::Android.write_diff( hash )
    end

  end

  describe 'write' do

    it 'writes the translation to a xml file' do
      translation = { 'app_name' => 'Kid Mode', 'pd_app_name' => 'Parent Dashboard' }
      path = "#{vocab_root}/spec/tmp/strings.xml"
      Vocab::Extractor::Android.write( translation, path )
      should_eql_file( File.open( path ) { |f| f.read },
                       "spec/data/android/write.xml" )
      File.delete( path )
    end

  end

end