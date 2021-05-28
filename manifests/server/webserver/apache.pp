# TODO: Replace all this with Apache vhost definitions rather
# that this hardcoded stuff

class lemonldap::server::webserver::apache(
  Boolean $do_soap          = false,
  String $ssl_ca_path       = $lemonldap::server::ss_ca_path,
  String $ssl_cert_path     = $lemonldap::server::ss_cert_path,
  String $ssl_key_path      = $lemonldap::server::ss_key_path,
  Boolean $webserver_manage = true
){
  $domain         = $lemonldap::params::domain
  $manager_domain = $lemonldap::params::manager_domain
  $reload_domain  = $lemonldap::params::reload_domain
  $auth_domain    = $lemonldap::params::auth_domain
  $reset_domain   = $lemonldap::params::reset_domain
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
