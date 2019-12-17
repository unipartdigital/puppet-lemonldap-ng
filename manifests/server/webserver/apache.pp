class lemonldap::server::webserver::apache(
  Boolean $do_soap = false,
  String $domain   = undef
){
  $srvname       = $::osfamily ? {
    "RedHat" => "httpd",
    default  => "apache2"
  }

  #replace all of this with apache::vhost {}

  lemonldap::server::webserver::portalsoap {
    "apache":
      do_soap => $do_soap,
  }
  file {
    '/etc/httpd/conf.d/z-lemonldap-ng-handler.conf':
      template => "${::module_name}${title}",
      owner    => 'root',
      group    => 'root',
      mode     => '0644',
  }
  file {
    '/etc/httpd/conf.d/z-lemonldap-ng-portal.conf':
      template => "${::module_name}${title}",
      owner    => 'root',
      group    => 'root',
      mode     => '0644',
  }
  file {
    '/etc/httpd/conf.d/z-lemonldap-ng-manager.conf':
      template => "${::module_name}${title}",
      owner    => 'root',
      group    => 'root',
      mode     => '0644',
  }
}
