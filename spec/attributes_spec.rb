require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class SampleAttributes
  include PaymentsGateway::Attributes
  attr_accessor :attr1, :attr2
end

describe PaymentsGateway::Attributes do

  before(:each) do
    @attr = SampleAttributes.new
  end

  context "#attributes=" do
    before(:each) do
      @attr.attributes = {:attr1 => true, :attr2 => false}
    end

    it "should set the attributes correctly" do
      @attr.attr1.should be_true
      @attr.attr2.should be_false
    end
  end

  context "#to_pg_hash" do
    it "should build the pg hash" do
      pending "Need to write test"
    end
  end

  context "#cast_value_for_key" do
    it "should convert expiration date to YYYYMM format" do
      @attr.cast_value_for_key('cc_expiration_date', Date.parse('2012-01-01')).should == '201201'
    end

    it "should convert is default to a string that is either 'true' or 'false'" do
      @attr.cast_value_for_key('is_default', true).should == 'true'
      @attr.cast_value_for_key('is_default', false).should == 'false'
      @attr.cast_value_for_key('is_default', 'true').should == 'true'
      @attr.cast_value_for_key('is_default', 'false').should == 'false'
      @attr.cast_value_for_key('is_default', nil).should == 'false'
    end

    it "should convert card type to upcased string" do
      @attr.cast_value_for_key('cc_card_type', 'visa').should == 'VISA'
      @attr.cast_value_for_key('cc_card_type', :mast).should == 'MAST'
    end
  end

end
