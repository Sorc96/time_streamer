# frozen_string_literal: true

module TimeStreamer
  CONFIGURABLE_VALUES = %i[
    adapter
    global_ignored_associations
    ignored_associations
    mount_path
  ].freeze

  Configuration = Struct.new(*CONFIGURABLE_VALUES, keyword_init: true)

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new(
      adapter: Adapters::Audited.new,
      global_ignored_associations: [],
      ignored_associations: {},
      mount_path: '/time_streamer'
    )
  end
end
