function securden::delete_accounts(
  Optional[Hash] $params = {}
) {
  $account_ids = $params['account_ids'] ? { undef => undef, default => $params['account_ids'] }
  $reason = $params['reason'] ? { undef => undef, default => $params['reason'] }
  $delete_permanently  = $params['delete_permanently']  ? { undef => undef, default => $params['delete_permanently'] }

  $server_url  = $securden::conf::server_url
  $authtoken   = $securden::conf::authtoken
  $org         = $securden::conf::org
  $certificate = $securden::conf::certificate

  $account_data = delete_accounts(
    $server_url,
    $authtoken,
    $org,
    $certificate,
    $account_ids,
    $reason,
    $delete_permanently
  )
  return $account_data
}
