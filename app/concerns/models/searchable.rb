module Models
  module Searchable
    extend ActiveSupport::Concern
    
    included do
      after_create  :create_indextank_document
      after_update  :update_indextank_document
      after_destroy :destroy_indextank_document
    end
    
    module ClassMethods
      def search(text)
        text.strip!
        query = ["title:#{text}^2", "content:#{text}"].join(' OR ')
        doc_ids = index.search(query)['results'].map do |doc|
          doc['docid']
        end
        where(:id => doc_ids)
      end

      def index
        @@index ||= $indextank.indexes(index_name)
      end

    protected

      def index_name
        Rails.env.production? ? :postsx : :postsx_dev
      end
    end
    
    module InstanceMethods
    protected
      
      def create_indextank_document
        Post.index.document(id).add(title: title, content: content)
      end

      def update_indextank_document
        Post.index.document(id).add(title: title, content: content)
      end

      def destroy_indextank_document
        Post.index.document(id).delete
      end
    end
  end
end