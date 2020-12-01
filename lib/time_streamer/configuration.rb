# frozen_string_literal: true

module TimeStreamer
  CONFIGURABLE_VALUES = %i[
    adapter
    global_ignored_associations
    ignored_associations
    mount_path
  ].freeze

  Configuration = Struct.new(*CONFIGURABLE_VALUES)

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new(
      Adapters::Audited.new, # adapter
      [],                    # global_ignored_associations
      {},                    # ignored_associations
      '/time_streamer'       # mount_path
    )
  end
end
