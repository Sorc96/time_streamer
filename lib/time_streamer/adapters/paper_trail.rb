# frozen_string_literal: true

module TimeStreamer
  module Adapters
    class PaperTrail
      def search_placeholder
        'ItemType#ItemId'
      end

      def identifier_for(record)
        "#{record.class}##{record&.id}"
      end

      def find_version(id)
        ::PaperTrail::Version.find id
      end

      def find_versions_by_search_term(search_term)
        item_type, item_id = search_term.split '#', 2
        ::PaperTrail::Version.includes(:item)
                             .where(item_type: item_type, item_id: item_id)
                             .order created_at: :desc
      end

      def record_at_version(version)
        version.item.paper_trail.version_at version.created_at
      end

      def current_record_from_version(version)
        version.item
      end

      def versions_of_record(record)
        record.versions.reorder created_at: :desc
      end

      def version_data(version)
        {
          id: version.id.to_s,
          title: "#{version.created_at.strftime '%-d. %-m. %Y %H:%M:%S'} - #{version.event}",
          metadata: "Request UUID: #{version.whodunnit}",
          changes: version.changeset
        }
      end
    end
  end
end
