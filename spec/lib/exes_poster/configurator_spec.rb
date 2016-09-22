require 'rails_helper'

RSpec.describe ExesPoster::Configurator do
  context 'included_module' do
    let(:included_module) do
      Module.new {
        module_eval <<-EOS
          @@hoge = 'hoge'
          @@fuga = nil
        EOS
        include ExesPoster::Configurator
      }
    end

    subject { included_module }

    it 'should be defined getter methods for module variables' do
      is_expected.to respond_to :hoge
      is_expected.to respond_to :fuga
    end

    it 'should be defined setter methods for module variables' do
      is_expected.to respond_to :hoge=
      is_expected.to respond_to :fuga=
    end

    it 'should set to default value' do
      expect(subject.hoge).to eq 'hoge'
      expect(subject.fuga).to be_nil
    end

    it { is_expected.to respond_to :setup }

    context '.setup' do
      before {
        included_module.setup do |config|
          config.hoge = nil
          config.fuga = 'fuga'
        end
      }
      it 'Module variables should be overwritten' do
        expect(subject.hoge).to be_nil
        expect(subject.fuga).to eq 'fuga'
      end
    end
  end
end
