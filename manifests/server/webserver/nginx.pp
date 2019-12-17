class lemonldap::server::webserver::nginx(
  Boolean $do_soap = false,
  String $domain   = undef
){

  lemonldap::server::webserver::setdomain {
    $lemonldap::vars::webserver_conf:
      domain    => $domain,
      webserver => "nginx";
  }

  lemonldap::server::webserver::portalsoap {
    "nginx":
      do_soap => $do_soap,
  }
}
