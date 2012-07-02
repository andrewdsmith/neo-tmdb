require 'spec_helper'

module TMDb
  class ExampleExtendedClass
    extend Attributes
    tmdb_attr :foo
    def initialize(attrs)
      @tmdb_attrs = attrs
    end
  end

  describe Attributes do
    describe '.tmdb_attr' do
      let(:example_instance) { ExampleExtendedClass.new('foo' => 'bar') }
      it 'adds a method with the given name' do
        example_instance.public_methods.should include(:foo)
      end
      it 'makes the method delegate to the @tmdb_attrs entry of the same name' do
        example_instance.foo.should == 'bar'
      end
    end
  end
end
