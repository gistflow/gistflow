# coding: utf-8
module FlashHelper
  def notification_block(type, message)
    content_tag :div, :class => alert_classes(type) do
      concat(content_tag :a, "×", :class => 'close')
      concat message
    end
  end

  def render_flash
    flash.map do |type, message|
      notification_block type, message
    end.join.html_safe
  end

  def render_error_messages(object)
    if object.errors.any?
      content_tag :ul, class: :errors do
        object.errors.full_messages.map do |message|
          content_tag :li, notification_block(:alert, message)
        end.join.html_safe
      end
    end
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
