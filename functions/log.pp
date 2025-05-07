function abi::log (
  String $level,
  String $message,
) {
  # Map the log level to Puppet's notify loglevel
  notify { $message:
    loglevel => $level,
  }
}
