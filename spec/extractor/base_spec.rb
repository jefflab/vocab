require "spec_helper"

describe "Vocab::Extractor::Base" do

  describe "diff" do

    it "finds the new keys in the current hash" do
      @current = { 1 => 2, 3 => 4 }
      @previous = { 1 => 2 }
      diff = Vocab::Extractor::Base.diff( @previous, @current )
      diff.should == { 3 => 4 }
    end

    it "finds the udpated keys in the current hash" do
      @current = { 1 => 10 }
      @previous = { 1 => 2 }
      diff = Vocab::Extractor::Base.diff( @previous, @current )
      diff.should == { 1 => 10 }
    end

    it "handles the hash format of the translations" do
      @current =  { :"en.marketing.banner"=>"This product is so good",
                    :"en.models.product.id_125.name"=>"This has been updated",
                    :"en.models.product.id_126.name"=>"This is new"}
      @previous = { :"en.marketing.banner"=>"This product is so good",
                    :"en.models.product.id_125.name"=>"Lazer"}
      diff = Vocab::Extractor::Base.diff( @previous, @current )
      diff.should == { :"en.models.product.id_125.name"=>"This has been updated",
                       :"en.models.product.id_126.name"=>"This is new"}
    end

  end

  describe "extract" do

    before( :each ) do
      @path = "#{vocab_root}/spec/tmp/en.yml"
      File.delete( @path ) if File.exists?( @path )
    end

    it "extracts the strings that need to be translated into a yml file" do
      Vocab::Extractor::Base.should_receive( :extract_current ).and_return( { 1 => 5, 3 => 4 } )
      Vocab::Extractor::Base.should_receive( :extract_previous ).and_return( { 1 => 2 } )
      Vocab::Extractor::Base.should_receive( :write_diff ).with( { 1 => 5, 3 => 4 }, @path )
      Vocab::Extractor::Base.extract( @path )
    end

  end

end