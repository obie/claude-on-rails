# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'fileutils'

RSpec.describe ClaudeOnRails::ProjectAnalyzer do
  let(:tmpdir) { Dir.mktmpdir }
  let(:analyzer) { described_class.new(tmpdir) }

  after { FileUtils.rm_rf(tmpdir) }

  describe '#analyze' do
    it 'returns a hash with expected keys' do
      result = analyzer.analyze

      expect(result).to be_a(Hash)
      expect(result).to include(
        :api_only,
        :test_framework,
        :has_graphql,
        :has_turbo,
        :has_devise,
        :has_sidekiq,
        :javascript_framework,
        :database,
        :deployment,
        :custom_patterns
      )
    end

    context 'with a standard Rails app' do
      before do
        # Create minimal Rails structure
        FileUtils.mkdir_p(File.join(tmpdir, 'config'))
        File.write(File.join(tmpdir, 'config', 'application.rb'),
                   "module MyApp\n  class Application < Rails::Application\n  end\nend")
        File.write(File.join(tmpdir, 'Gemfile'), "gem 'rails'")
      end

      it "detects it's not API-only" do
        expect(analyzer.analyze[:api_only]).to be false
      end
    end

    context 'with an API-only Rails app' do
      before do
        FileUtils.mkdir_p(File.join(tmpdir, 'config'))
        File.write(File.join(tmpdir, 'config', 'application.rb'),
                   "module MyApp\n  class Application < Rails::Application\n    config.api_only = true\n  end\nend")
      end

      it 'detects API-only configuration' do
        expect(analyzer.analyze[:api_only]).to be true
      end
    end

    context 'test framework detection' do
      it 'detects RSpec' do
        FileUtils.mkdir_p(File.join(tmpdir, 'spec'))
        expect(analyzer.analyze[:test_framework]).to eq 'RSpec'
      end

      it 'detects Minitest' do
        FileUtils.mkdir_p(File.join(tmpdir, 'test'))
        expect(analyzer.analyze[:test_framework]).to eq 'Minitest'
      end

      it 'returns nil when no test framework is found' do
        expect(analyzer.analyze[:test_framework]).to be_nil
      end
    end

    context 'gem detection' do
      before do
        File.write(File.join(tmpdir, 'Gemfile'), gemfile_content)
      end

      context 'with GraphQL' do
        let(:gemfile_content) { "gem 'rails'\ngem 'graphql'" }

        it 'detects GraphQL' do
          expect(analyzer.analyze[:has_graphql]).to be true
        end
      end

      context 'with Turbo' do
        let(:gemfile_content) { "gem 'rails'\ngem 'turbo-rails'" }

        it 'detects Turbo' do
          expect(analyzer.analyze[:has_turbo]).to be true
        end
      end

      context 'with Devise' do
        let(:gemfile_content) { "gem 'rails'\ngem 'devise'" }

        it 'detects Devise' do
          expect(analyzer.analyze[:has_devise]).to be true
        end
      end
    end

    context 'deployment detection' do
      it 'detects Kamal when config/deploy.yml and Dockerfile both exist' do
        FileUtils.mkdir_p(File.join(tmpdir, 'config'))
        File.write(File.join(tmpdir, 'config', 'deploy.yml'), 'service: my-app')
        File.write(File.join(tmpdir, 'Dockerfile'), 'FROM ruby:3.3')
        expect(analyzer.analyze[:deployment]).to eq 'kamal'
      end

      it 'detects Docker when only Dockerfile exists' do
        File.write(File.join(tmpdir, 'Dockerfile'), 'FROM ruby:3.3')
        expect(analyzer.analyze[:deployment]).to eq 'docker'
      end

      it 'detects Kubernetes when k8s directory exists' do
        FileUtils.mkdir_p(File.join(tmpdir, 'k8s'))
        expect(analyzer.analyze[:deployment]).to eq 'kubernetes'
      end

      it 'detects Capistrano when Capfile exists' do
        File.write(File.join(tmpdir, 'Capfile'), '')
        expect(analyzer.analyze[:deployment]).to eq 'capistrano'
      end

      it 'detects Heroku when Procfile exists' do
        File.write(File.join(tmpdir, 'Procfile'), 'web: bundle exec rails server')
        expect(analyzer.analyze[:deployment]).to eq 'heroku'
      end

      it 'returns unknown when no deployment config is found' do
        expect(analyzer.analyze[:deployment]).to eq 'unknown'
      end
    end

    context 'custom patterns detection' do
      it 'detects service objects directory' do
        FileUtils.mkdir_p(File.join(tmpdir, 'app', 'services'))
        patterns = analyzer.analyze[:custom_patterns]
        expect(patterns[:has_services]).to be true
      end

      it 'detects form objects directory' do
        FileUtils.mkdir_p(File.join(tmpdir, 'app', 'forms'))
        patterns = analyzer.analyze[:custom_patterns]
        expect(patterns[:has_forms]).to be true
      end
    end
  end
end
