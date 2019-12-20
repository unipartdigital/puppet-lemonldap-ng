# == Class: lemonldap::params
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Clément Oudot <clement.oudot@savoirfairelinux.com>
# Seth Tunstall <seth.tunstall@unipart.io>
#

class lemonldap::params (
  $company            = 'LemonLDAP::NG',
){
  $gpg_pubkey_id      = '81F18E7A'
  $webserver_conf     = [ 'handler', 'manager', 'portal', 'test' ]
  $webserver_prefixes = [ 'reload', 'manager', 'auth', 'test1' ]
  $llng_dir           = '/usr/share/lemonldap-ng'
  $ldap_host          = lookup('ldap_server')
  $ldap_base_dn       = lookup('ldap_base_dn')
  $ldap_user          = lookup('serviceuser')
  $ldap_password      = lookup('ldap_serviceuser')
}
