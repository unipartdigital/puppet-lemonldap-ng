# == Class: lemonldap::server
#
#   Installs LemonLDAP backend
#
# === Parameters
#
# [*do_soap*]
#   Should we configure webserver to serve SOAP-related requests? Defaults
#   to 'False'.
# [*do_ssl*]
#   Should we configure webserver to serve LLNG using SSL & HTTPS? Defaults
#   to 'False'.
# [*domain*]
#   The root domain we would setup LLNG services on top of. Beware a default
#   install would setup virtualhosts for (reload|manager|auth|test1).yourdomain
#   Defaults to 'undef'.
# [*sessionstore*]
#   What kind of sessions storage would we use. Can be `MySQL`, `PostgreSQL`,
#   `LDAP`, `Redis`, `MongoDB`, `Browseable` or `SOAP`. Defaults to `File`.
# [*ssl_ca_path*]
#   When 'do_ssl' is 'True', set here your custom CA path. Defaults to 'undef'.
# [*ssl_cert_path*]
#   When 'do_ssl' is 'True', set here your certificate. Make sure its CN would
#   match all your virtualhosts hostnames. Defaults to 'undef'.
# [*ssl_key_path*]
#   When 'do_ssl' is 'True', set here your certificate key. Defaults to 'undef'.
# [*webserver*]
#   Chose from 'apache' or 'nginx'. Defaults to 'apache'.
#
# === Variables
#
# === Authors
#
# Clément Oudot <clement.oudot@savoirfairelinux.com>
# Seth Tunstall <seth.tunstall@unipart.io>
#

class lemonldap::server (
  Boolean $do_soap      = false,
  Boolean $do_ssl       = false,
  String $domain        = undef,
  String $maildomain    = undef,
  String $company       = 'LemonLDAP::NG',
  String $sessionstore  = "File",
  String $ssl_ca_path   = undef,
  String $ssl_cert_path = undef,
  String $ssl_key_path  = undef,
  String $lemonldap_ini = '/etc/lemonldap-ng/lemonldap-ng.ini',
  String $webserver     = "apache") {
    include lemonldap::params
    include lemonldap::repo
    include lemonldap::branding

    # Execute OS specific actions
    case $::osfamily {
      "Debian": {
        class {
          lemonldap::server::operatingsystem::debian:
            sessionstore => $sessionstore,
            webserver    => $webserver;
        }
      }
      "RedHat": {
        class {
          lemonldap::server::operatingsystem::redhat:
            sessionstore => $sessionstore,
            webserver    => $webserver;
        }
      }
      default: {
        fail("Module ${module_name} is not supported on ${::operatingsystem}")
      }
    }

    # LemonLDAP packages
    package {
      [ "lemonldap-ng", "lemonldap-ng-fr-doc" ]:
        ensure => installed,
    }

    file { $lemonldap_ini:
      content => template("${module_name}${lemonldap_ini}.erb"),
      owner   => 'apache',
      group   => 'apache',
      mode    => '0644',
    }


    case $webserver {
      "apache", "httpd": {
        class {
          lemonldap::server::webserver::apache:
            do_soap => $do_soap,
            domain  => $domain;
        }
      }
      "nginx": {
        class {
          lemonldap::server::webserver::nginx:
            do_soap => $do_soap,
            domain  => $domain;
        }
      }
      default: {
        fail("Module ${module_name} needs apache or nginx webserver")
      }
    }

    # Set vhost in /etc/hosts
    each($lemonldap::params::webserver_prefixes) |$prefix| {
      host {
        "$prefix.$domain":
          ip => $::ipaddress;
      }
    }
  }
