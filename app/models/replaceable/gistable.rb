module Replaceable
  module Gistable
    def replace_gists!
      #self.content = CGI::escapeHTML(self.content)
      
      self.content = self.content.gsub(/\{gist:(\d+)\}/) do
        content_tag(:div, "", :class => "gistable", :"data-gist-at" => $1)
      end.html_safe
      self
    end
  end
end