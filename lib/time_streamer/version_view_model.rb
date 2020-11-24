# frozen_string_literal: true

module TimeStreamer
  class VersionViewModel
    attr_reader :id, :title, :metadata, :changes

    def initialize(id:, title:, metadata:, changes:)
      @id = id
      @title = title
      @metadata = metadata
      @changes = changes
    end
  end
end
