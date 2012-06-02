module Models
  # Add preview and body methods to record
  # record should have content method which returns full raw text
  module Cuttable
    extend ActiveSupport::Concern
    
    CUT = /<cut(\stext\s?=\s?\\?[\",']([^[\",',\\]]*)\\?[\",']\s?)?>/
    
    def preview
      content_parts.first.to_s.strip
    end

    def body
      content.sub(CUT, "\r\n")
    end
    
    def cut_text
      if content_parts.size > 1
        content[CUT, 2] || I18n.translate(:default_cut)
      end
    end
    
  protected
    
    def content_parts
      m = content.split(CUT, 2)
      @content_parts ||= [m.first, m.last].uniq.compact
    end
  end
end