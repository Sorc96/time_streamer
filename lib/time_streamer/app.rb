# frozen_string_literal: true

require 'sinatra/base'

module TimeStreamer
  class App < Sinatra::Base
    get '/' do
      puts params
      @search_placeholder = adapter.search_placeholder
      @search_term = params[:search_term].to_s
      versions = adapter.find_versions_by_search_term @search_term
      @record = adapter.current_record_from_version(versions.first) if versions.any?
      @associations = associations_for @record
      @header = "#{adapter.identifier_for @record} - latest version"
      @versions = versions_to_view_models versions
      erb :index
    end

    get '/:id' do
      @search_placeholder = adapter.search_placeholder
      version = adapter.find_version params[:id]
      @record = adapter.record_at_version version
      @versions = versions_to_view_models adapter.versions_of_record(@record)
      @search_term = adapter.identifier_for @record
      @associations = associations_for @record
      @header = "#{adapter.identifier_for @record} - at #{format_time version.created_at}"
      erb :index
    end

    ###
  
    def associations_for(parent)
      return if parent.nil?
  
      associations = load_associations parent
      associations.transform_values! do |value|
        Array(value).map { |record| adapter.identifier_for(record) }
      end
      associations.reject { |_, value| value.empty? }
    end
  
    def load_associations(record)
      associations = record.class.reflections.keys - ignored_associations(record.class)
      associations.map { |key| [key, record.send(key)] }.to_h
    end
  
    def format_time(time)
      time.strftime '%Y-%m-%d %H:%M:%S'
    end
  
    def versions_to_view_models(versions)
      versions.map { |version| VersionViewModel.new adapter.version_data(version) }
    end

    def adapter
      TimeStreamer.configuration.adapter
    end

    def ignored_associations(model_class)
      global = TimeStreamer.configuration.global_ignored_associations
      specific = TimeStreamer.configuration.ignored_associations.fetch(model_class.to_s) { [] }
      global | specific
    end

    def mount_path
      TimeStreamer.configuration.mount_path
    end
  end
end
