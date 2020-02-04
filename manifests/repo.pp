# Class: lemonldap::repo: Configures OS-specific repos
class lemonldap::repo (
){
  case $::osfamily {
    'RedHat': {
      yumrepo { 'lemonldap-ng':
        descr    => 'LemonLDAP::NG packages',
        baseurl  => 'https://lemonldap-ng.org/redhat/stable/$releasever/noarch/',
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'https://lemonldap-ng.org/_media/rpm-gpg-key-ow2',
      }
      yumrepo { 'lemonldap-ng-extras':
        descr    => 'LemonLDAP::NG extras',
        baseurl  => 'https://lemonldap-ng.org/redhat/extras/$releasever/',
        enabled  => '1',
        gpgcheck => '1',
        gpgkey   => 'https://lemonldap-ng.org/_media/rpm-gpg-key-ow2',
      }
    }
    default: {
      notify { 'Not Yet Written :-)': }
    }
  }
}
