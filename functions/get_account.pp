function securden::get_account(
  Optional[Hash] $params = {}
) {
  $account_id    = $params['account_id']    ? { undef => undef, default => $params['account_id'] }
  $account_title = $params['account_title'] ? { undef => undef, default => $params['account_title'] }
  $account_name  = $params['account_name']  ? { undef => undef, default => $params['account_name'] }
  $account_type  = $params['account_type']  ? { undef => undef, default => $params['account_type'] }
  $ticket_id  = $params['ticket_id']  ? { undef => undef, default => $params['ticket_id'] }
  $reason  = $params['reason']  ? { undef => undef, default => $params['reason'] }

  $server_url  = $securden::conf::server_url
  $authtoken   = $securden::conf::authtoken
  $org         = $securden::conf::org
  $certificate = $securden::conf::certificate

  $account_data = get_account(
    $server_url,
    $authtoken,
    $org,
    $certificate,
    $account_id,
    $account_title,
    $account_name,
    $account_type,
    $ticket_id,
    $reason,
  )
  return $account_data
}
