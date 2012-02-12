# coding: utf-8
module FlashHelper
  def render_flash
    capture_haml do
      flash.each do |type, message|
        haml_tag :div, :class => alert_classes(type) do
          haml_tag :a, :class => 'close' do
            haml_concat "×"
          end
          haml_concat message
        end
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
