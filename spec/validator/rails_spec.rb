require "spec_helper"

describe "Vocab::Validator::Rails" do

  before( :each ) do
    @locales_dir = "#{vocab_root}/spec/data/rails/locales"
    @validator = Vocab::Validator::Rails.new( @locales_dir )
  end

  describe 'validate_file' do

    before( :each ) do
      @path = "#{vocab_root}/spec/data/rails/locales/es.yml"
    end

    it 'returns a hash containing the missing keys' do
      result = @validator.validate_file( @path )
      result[ :missing ].should =~ [ "menu.first", "menu.second", "not_in_es" ]
    end

    it 'returns a hash containing the extra keys' do
      @validator.should_receive( :english_keys ).and_return( [ 'foo' ] )
      @validator.should_receive( :other_keys ).and_return( [ 'foo', 'extra', 'stuff' ] )
      result = @validator.validate_file( @path )
      result[ :extra ].should eql( [ 'extra', 'stuff' ] )
    end

  end

  describe 'files_to_validate' do

    it 'returns the locale files to validate' do
      files = ["#{@locales_dir}/es.yml",
               "#{@locales_dir}/models/product/es.yml"]
      @validator.files_to_validate.should eql( files )
    end

  end

  describe 'validate' do

    it 'validates android locales files' do
      files = @validator.files_to_validate
      files.each { |file| @validator.should_receive( :validate_file ).with( file ) }
      @validator.should_receive( :print ).exactly( files.size ).times
      @validator.validate
    end

    it 'prints without exception' do
      @validator.validate
    end

  end

  describe 'other_keys' do

    before( :each ) do
      @file = "#{@locales_dir}/es.yml"
      @validator = Vocab::Validator::Rails.new( @locales_dir )
    end

    it 'returns the flattened keys from the file' do
      keys = ["dashboard.chart", "dashboard.details", "marketing.banner"]
      @validator.other_keys( @file ).should =~ keys
    end

  end

  describe 'english_keys' do

    before( :each ) do
      @file = "#{@locales_dir}/es.yml"
      @validator = Vocab::Validator::Rails.new( @locales_dir )
    end

    it 'returns the flattened keys from english equivalent file' do
      keys = ["dashboard.chart", "dashboard.details", "marketing.banner", "menu.first", "menu.second", "not_in_es"]
      @validator.english_keys( @file ).should =~ keys
    end

  end

end