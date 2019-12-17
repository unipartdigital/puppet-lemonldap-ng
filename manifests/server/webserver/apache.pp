class lemonldap::server::webserver::apache(
  Boolean $do_soap = false,
  String $domain   = undef
){
  $vhosts = [ 
    '/etc/httpd/conf.d/z-lemonldap-ng-handler.conf', 
    '/etc/httpd/conf.d/z-lemonldap-ng-portal.conf', 
    '/etc/httpd/conf.d/z-lemonldap-ng-manager.conf'
  ]

  $srvname       = $::osfamily ? {
    "RedHat" => "httpd",
    default  => "apache2"
  }

  #replace all of this with apache::vhost {}

  #lemonldap::server::webserver::portalsoap {
  #  "apache":
  #    do_soap => $do_soap,
  #}
  $vhosts.each | $vhost | {
    file { $vhost:
        source => template("${module_name}${vhost}.erb"),
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }
  }
}
