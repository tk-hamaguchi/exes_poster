require 'rails_helper'

RSpec.describe ExesPoster::Poster do
  context 'included_module' do
    let(:included_module) do
      Module.new {
        def self.es_url ; end
        def self.es_index ; end
        include ExesPoster::Poster
      }
    end

    subject { included_module }

    it { is_expected.to respond_to :post_exception }
    it { is_expected.to respond_to :post }

    context '.post_exception' do
      let(:client) { double(Elasticsearch::Client, index: { '_id' => document_id }) }
      let(:message) { double(String) }
      let(:backtrace) { double(Array) }
      let(:exception_class) { double(String) }
      let(:exception) { double(RuntimeError, message: message, backtrace: backtrace, class: double(Class, name: exception_class)) }
      let(:document_id) { double(String) }
      let(:es_url) { double(String) }
      let(:es_index) { double(String) }
      before do
        Timecop.freeze(Time.parse('2016-09-22T10:23:40.829+09:00'))
        allow(Elasticsearch::Client).to receive(:new).and_return(client)
        allow(included_module).to receive(:es_url).and_return(es_url)
        allow(included_module).to receive(:es_index).and_return(es_index)
      end
      subject { included_module.post_exception(exception) }
      it { is_expected.to eq document_id }

      context 'then' do
        context 'Elasticsearch::Client' do
          after { included_module.post_exception(exception) }
          subject { Elasticsearch::Client }
          it { is_expected.to receive(:new).with(url: es_url) }
          context 'instance' do
            subject { client }
            it { is_expected.to receive(:index).with(index: es_index, type: :exception, body: { message: message, '@timestamp' => '2016-09-22T10:23:40.829+09:00', detail: { class: exception_class, backtrace: backtrace}}, refresh: true) }
          end
        end
      end
    end


    context '.post' do
      let(:client) { double(Elasticsearch::Client, index: { '_id' => document_id }) }
      let(:message) { double(String) }
      let(:document_id) { double(String) }
      let(:es_url) { double(String) }
      let(:es_index) { double(String) }
      let(:type) { double(String) }
      before do
        Timecop.freeze(Time.parse('2016-09-22T10:23:40.829+09:00'))
        allow(Elasticsearch::Client).to receive(:new).and_return(client)
        allow(included_module).to receive(:es_url).and_return(es_url)
        allow(included_module).to receive(:es_index).and_return(es_index)
      end
      subject { included_module.post(type, message) }
      it { is_expected.to eq document_id }

      context 'then' do
        context 'Elasticsearch::Client' do
          after { included_module.post(type, message) }
          subject { Elasticsearch::Client }
          it { is_expected.to receive(:new).with(url: es_url) }
          context 'instance' do
            subject { client }
            it { is_expected.to receive(:index).with(index: es_index, type: type, body: { message: message, '@timestamp' => '2016-09-22T10:23:40.829+09:00'}, refresh: true) }
          end
        end
      end

    end
  end
end
