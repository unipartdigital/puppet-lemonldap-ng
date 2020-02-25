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

class lemonldap::params {
  String $domain                 = 'site.example.com', # Override with hiera
  String $maildomain             = 'example.com', # Override with hiera
  String $gpg_pubkey_id          = '81F18E7A'
  $webserver_conf                = [ 'handler', 'manager', 'portal', 'test' ]
  $webserver_prefixes            = [ 'reload', 'manager', 'auth', 'test1' ]
}
