SimpleForm.setup do |config|
  config.components = [ :label, :contained_input ]
  SimpleForm.wrapper_class = 'clearfix'
  SimpleForm.wrapper_error_class = 'error'
  SimpleForm.error_class = 'help-inline'

  require 'simple_form/contained_input_component.rb'
end
