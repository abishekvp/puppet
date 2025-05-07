class securden (
  String $server_url,
  String $authtoken,
  Optional[String] $org = undef,
  Optional[String] $certificate = undef,
) {
  class { 'securden::conf':
    server_url  => $server_url,
    authtoken   => $authtoken,
    org         => $org,
    certificate => $certificate,
  }
}
