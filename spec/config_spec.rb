require 'spec_helper'

module Murga
  describe Config do
    let(:base_options) { { base_dir: EXAMPLE1_ROOT.to_s } }
    let(:options) { base_options }
    subject { described_class.new options }
    let(:custom) { described_class.new(base_options.merge(custom_options)) }
    context 'host' do
      let(:custom_options) { { host: '1.2.3.4' } }
      it('default') { expect(subject.host).to eq '0.0.0.0' }
      it('custom ') { expect(custom.host).to eq custom_options[:host] }
    end
    context 'port' do
      let(:custom_options) { { port: 12345 } }
      it('default') { expect(subject.port).to eq 3000 }
      it('custom ') { expect(custom.port).to eq custom_options[:port] }
    end
    context 'address' do
      let(:custom_options) { { host: '1.2.3.4' } }
      it('default') do
        expect(subject.address).to be_a java.net.InetAddress
        expect(subject.address.to_s).to eq '/0.0.0.0'
      end
      it('provided') do
        expect(custom.address).to be_a java.net.InetAddress
        expect(custom.address.to_s).to eq '/1.2.3.4'
      end
    end
    context 'env' do
      let(:custom_options) { { env: 'x' } }
      it('default') { expect(subject.env).to eq 'development' }
      it('custom ') { expect(custom.env).to eq custom_options[:env] }
    end
    context 'handlers' do
      let(:handler) { Murga::Handler::Basic }
      let(:custom_options) { { handlers: [handler] } }
      it('default') { expect(custom.handlers).to eq Set.new([handler]) }
      it('custom ') { expect(subject.handlers).to eq Set.new }
    end
    context 'base_dir' do
      let(:options) { { base_dir: path } }
      context 'when missing' do
        let(:options) { {} }
        it { expect { subject }.to_not raise_error }
      end
      context 'with a pathname' do
        let(:path) { EXAMPLE2_ROOT }
        it do
          expect(subject.base_dir).to be_a java.nio.file.Path
          expect(subject.base_dir.to_s).to eq path.to_s
          expect(subject.base_path).to eq path
        end
      end
      context 'with a string' do
        let(:path) { EXAMPLE2_ROOT.to_s }
        it do
          expect(subject.base_dir).to be_a java.nio.file.Path
          expect(subject.base_dir.to_s).to eq path
          expect(subject.base_path).to eq EXAMPLE2_ROOT
        end
      end
      context 'from the classpath' do
        let(:path) { EXAMPLE1_ROOT.to_s }
        before { $CLASSPATH << path }
        it do
          expect(subject.base_dir).to be_a java.nio.file.Path
          expect(subject.base_dir.to_s).to eq path
          expect(subject.base_path).to eq EXAMPLE1_ROOT
        end
      end
    end
    context 'props' do
      context 'without file' do
        let(:options) { { base_dir: EXAMPLE2_ROOT.to_s } }
        it { expect(subject.props?).to be_falsey }
      end
      context 'with file' do
        let(:options) { { base_dir: EXAMPLE1_ROOT.to_s } }
        it { expect(subject.props?).to be_truthy }
      end
      context 'with options' do
        let(:name) { 'some.properties' }
        let(:options) { base_options.merge props_name: name }
        it { expect(subject.props?).to be_falsey }
        it { expect(subject.props_name).to eq name }
      end
    end
    context 'server_config' do
      it 'works' do
        expect(subject.server_config.class.name).to eq 'Java::RatpackServerInternal::DefaultServerConfigBuilder'
      end
    end
  end
end
