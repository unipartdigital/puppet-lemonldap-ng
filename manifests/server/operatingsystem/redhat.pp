class lemonldap::server::operatingsystem::redhat(
  String $sessionstore = 'File',
  String $webserver    = 'apache',
) {
    $gpg_pubkey_id     = $lemonldap::params::gpg_pubkey_id
    case $sessionstore {
      /^[Mm]y[Ss][Qq][Ll]$/: {
        $packagesessions = [ 'mariadb-libs' ]
      }
      /^[Pp]ostgre([Ss][Qq][Ll]|s)$/: {
        $packagesessions = [ 'postgresql-libs' ]
      }
      /^[Rr]edis$/: {
        $packagesessions = [ 'redis' ]
      }
      default: {
        $packagesessions = false
      }
    }
    case $webserver {
      'nginx': {
        $packageswebserver = [ 'nginx', 'lemonldap-ng-fastcgi-server', 'perl-LWP-Protocol-https', 'lasso', 'perl-Glib', 'perl-XML-Simple' ]
      }
      'apache', 'httpd': {
        $packageswebserver = [ 'httpd', 'mod_perl', 'mod_fcgid', 'perl-LWP-Protocol-https', 'lasso', 'lasso-perl', 'perl-Glib', 'perl-XML-Simple' ]
      }
      default: {
        fail("Invalid webserver '${webserver}', please use nginx, apache or httpd")
      }
    }

    if $sessionstore {
      notify { 'Session store DB config goes here': }
    }

    if $packagewebserver {
      package {
        $packageswebserver:
          ensure  => present,
      }
    }
  }
