require 'rspec'

class RSpecGreeter
  def initialize
    @valid = false
  end
  
  def validate(a)
    @valid = a.odd?
  end

  def valid?
    @valid
  end

  def greet
    "Hello RSpec!"
  end

  def hello_with_name(name)
    if name.size > 4
      "#{name}, a big di.. *cof* name!"
    else
      name
    end
  end
end

RSpec.describe RSpecGreeter do
  describe '#greet' do
    it "should say 'Hello RSpec!'" do
      expect(subject.greet).to eq("Hello RSpec!")
    end
  end

  describe '#valid?' do
    subject { described_class.new }

    before { subject.validate(a) }

    context 'when the a is odd' do
      let(:a) { 1 }

      it "should be true" do
        is_expected.to be_valid
      end
    end

    context 'when the a is even' do
      let(:a) { 2 }

      it "should be false" do
        is_expected.to_not be_valid
      end
    end
  end

  
  describe '#hello_with_name' do
    subject { described_class.new.hello_with_name(name) }

    context 'when the name.size > 4' do
      let(:name) { 'Carlos' }

      it "should say ':name, a big di.. *cof* name!'" do
        expect(subject).to eq("#{name}, a bg di.. *cof* name!")
      end
    end

    context 'when the name.size <= 4' do
      let(:name) { 'Jan' }

      it "should say :name" do
        is_expected.to eq(name)
      end
    end
  end
end
  