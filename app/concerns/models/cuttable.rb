module Models
  # Add preview and body methods to record
  # record should have content method which returns full raw text
  # Also record must have a path method which returns path to record
  module Cuttable
    extend ActiveSupport::Concern
    
    CUT = /<cut(\stext\s?=\s?\\?[\",']([^[\",',\\]]*)\\?[\",']\s?)?>/
    
    def preview
      preview = content_parts.first.to_s.strip
      preview << "\n[#{cut_text}](#{path})" if cut_text
      preview
    end
    
    def body
      content.sub CUT, "\r\n"
    end
    
  protected
    
    def cut_text
      if content_parts.size > 1
        content[CUT, 2] || I18n.translate(:default_cut)
      end
    end
    
    def content_parts
      m = content.to_s.split(CUT, 2)
      @content_parts ||= [m.first, m.last].uniq.compact
    end
  end
end