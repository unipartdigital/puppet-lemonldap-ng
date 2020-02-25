# TODO: Replace all this with Apache vhost definitions rather
# that this hardcoded stuff

class lemonldap::server::webserver::apache(
  Boolean $do_soap          = false,
  String $domain            = $::lemonldap::params::domain,
  String $ssl_ca_path       = undef,
  String $ssl_cert_path     = undef,
  String $ssl_key_path      = undef,
  Boolean $webserver_manage = true
){
  $vhosts = [
    '/etc/httpd/conf.d/z-lemonldap-ng-handler.conf',
    '/etc/httpd/conf.d/z-lemonldap-ng-portal.conf',
    '/etc/httpd/conf.d/z-lemonldap-ng-manager.conf',
    '/etc/httpd/conf.d/z-lemonldap-ng-http.conf',
    '/etc/httpd/conf.d/ssl-puppet.conf',
  ]

  $srvname = $::osfamily ? {
    'RedHat' => 'httpd',
    default  => 'apache2'
  }

  #lemonldap::server::webserver::portalsoap {
  #  "apache":
  #    do_soap => $do_soap,
  #}
  $vhosts.each | $vhost | {
    file { $vhost:
        content => template("${module_name}${vhost}.erb"),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
  }

  if $webserver_manage {
    service { 'httpd':
      ensure => 'running',
      name   => $srvname,
      enable => true,
    }
  }
}
