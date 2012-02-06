module Replaceable
  module Gistable
    def replace_gists
      self.body = CGI::escapeHTML(self.body).gsub(/\{gist:(\d+)\}/) do
        '<div data-gist-at="' + $1 + '" class="gistable"></div>'
      end.html_safe
      self
    end
  end
end