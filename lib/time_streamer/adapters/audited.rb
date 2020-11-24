# frozen_string_literal: true

module TimeStreamer
  module Adapters
    class Audited
      def search_placeholder
        'AuditableType#AuditableId'
      end

      def identifier_for(record)
        "#{record.class}##{record&.id}"
      end

      def find_version(id)
        ::Audited::Audit.find id
      end

      def find_versions_by_search_term(search_term)
        auditable_type, auditable_id = search_term.split '#', 2
        ::Audited::Audit.where(auditable_type: auditable_type, auditable_id: auditable_id)
                        .order version: :desc
      end

      def record_at_version(version)
        version.revision
      end

      def current_record_from_version(version)
        version.auditable
      end

      def versions_of_record(record)
        record.audits.reorder version: :desc
      end

      def version_data(version)
        {
          id: version.id.to_s,
          title: "#{version.created_at.strftime '%-d. %-m. %Y %H:%M:%S'} - #{version.action}",
          metadata: "Request UUID: #{version.request_uuid}",
          changes: version.audited_changes
        }
      end
    end
  end
end
