require 'spec_helper'

module TMDb
  describe NullCache do
    let(:cache) { NullCache.new }

    describe '#fetch' do
      it 'yields to the passed blog' do
        expect { |block| cache.fetch('example_key', &block) }.to yield_control
      end
      it 'returns the value of the yielded block' do
        cache.fetch('example_key') { '123' }.should == '123'
      end
    end
  end
end
