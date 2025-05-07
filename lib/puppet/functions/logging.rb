# frozen_string_literal: true

@private
class Logger
  def self.log(level, message)
    message = "[SECURDEN] #{message}"
    case level
    when 'debug'
      Puppet.debug(message)
    when 'info'
      Puppet.info(message)
    when 'warning'
      Puppet.warning(message)
    when 'err'
      Puppet.err(message)
    when 'notice'
      Puppet.notice(message)
    end
  end
end
