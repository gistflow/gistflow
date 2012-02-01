module Replaceable
  module Gistable
    def replace_gists
      self.body = CGI::escapeHTML(self.body).gsub(/\{gist:(\d+)\}/) do
        Github::Gist.script_tag($1)
      end.html_safe
      self
    end
  end
end