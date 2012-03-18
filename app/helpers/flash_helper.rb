# coding: utf-8
module FlashHelper
  def render_flash
    flash.each do |type, message|
      content_tag :div, :class => alert_classes(type) do
        concat(content_tag :a, "×", :class => 'close')
        concat message
      end
    end
    nil
  end

protected
  
  def alert_classes(type)
    classes = [:alert]
    classes << case type.to_sym
    when :notice then
      :'alert-success'
    when :alert then
      :'alert-error'
    when :info then
      :'alert-info'
    end
    classes.join ' '
  end
end
