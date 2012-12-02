module Models
  module Searchable
    extend ActiveSupport::Concern

    included do
      include Tire::Model::Search
      include Tire::Model::Callbacks

      mapping do
        indexes :id,          index: :not_analyzed
        indexes :title,       analyzer: :snowball, boost: 2
        indexes :content,     analyzer: :snowball
        indexes :author_name, analyzer: :keyword
        indexes :is_private,  index: :not_analyzed, type: :boolean
      end

      def self.search(query, options = {})
        options.reverse_merge!(load: { include: :user })
        tire.search(options) do
          query { string query } if query.present?
          filter :term, { is_private: false }
        end
      end

      def author_name
        user.username
      end
    end
  end
end
