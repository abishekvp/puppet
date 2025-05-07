function abi::get_accounts(
  Optional[Hash] $params = {}
) {
  $account_ids = $params['account_ids'] ? { undef => undef, default => $params['account_ids'] }
  $accounts = $params['accounts'] ? { undef => undef, default => $params['accounts'] }

  $server_url  = $abi::conf::server_url
  $authtoken   = $abi::conf::authtoken
  $org         = $abi::conf::org
  $certificate = $abi::conf::certificate

  $accounts_data = get_accounts(
    $server_url,
    $authtoken,
    $org,
    $certificate,
    $account_ids,
    $accounts,
  )
  return $accounts_data
}
