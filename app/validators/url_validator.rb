#encoding: UTF-8
class UrlValidator < ActiveModel::EachValidator
  # validation regexp extracted from
  # https://github.com/henrik/validates_url_format_of/blob/master/init.rb
  
  IPv4_PART = /\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]/  # 0-255
  
  ALNUM = "ä".match(/[[:alnum:]]/) ? /[[:alnum:]]/ : /[^\W_]/

  REGEXP = %r{
    \A
    https?://                                                          # http:// or https://
    ([^\s:@]+:[^\s:@]*@)?                                              # optional username:pw@
    ( ((#{ALNUM}+\.)*xn--)?#{ALNUM}+([-.]#{ALNUM}+)*\.[a-z]{2,6}\.? |  # domain (including Punycode/IDN)...
        #{IPv4_PART}(\.#{IPv4_PART}){3} )                              # or IPv4
    (:\d{1,5})?                                                        # optional port
    ([/?]\S*)?                                                         # optional /whatever or ?whatever
    \Z
  }iux

  DEFAULT_MESSAGE = 'does not appear to be a valid URL'
    
  def validate_each(record, attribute, value)
    unless value =~ REGEXP
      record.errors[attribute] << DEFAULT_MESSAGE
    end
  end
end