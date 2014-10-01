############################################################
# Class: nfs
#
# Description:
# This configures the NFS server and NFS client mounts
#
# Variables:
# stig::nfsserver
#
# Facts:
# None
#
# Files:
# None
#
# Templates:
# None
#
# Dependencies:
# None
############################################################
# NFS class for configuring NFS service and state
class nfs ( $nfs_server_fqdn ) {

  if $stig::nfsserver {
    class { 'nfs::server': nfs_server_fqdn => $nfs_server_fqdn, }
  }
  else {
    service {
      'nfs':
        ensure    => false,
        enable    => false,
        hasstatus => true,
    }
  }

  package {
    'nfs-utils':
      ensure  => 'installed',
      require => Class['yum'],
  }

  service {
    'netfs':
      ensure    => true,
      enable    => true,
      hasstatus => true;

    'nfslock':
      ensure    => true,
      enable    => true,
      hasstatus => true,

    # NFSv3 and earlier only service
    # 'portmap':
    # ensure    => true,
    # enable    => true,
    # hasstatus => true,
    # NFSv4 only service
    #
    # 'rpcidmapd':
    # ensure    => true,
    # enable    => true,
    # hasstatus => true,
    # Kerberized NFS only service
    #
    # 'rpcgssd':
    # ensure    => true,
    # enable    => true,
    # hasstatus => true,
  }

  # Example of an NFS /home mount
  # mount {
  #   '/home':
  #     ensure  => 'mounted',
  #     device  => "$nfs_server_fqdn:/home",
  #     fstype  => 'nfs',
  #     options => 'defaults,rw,nodev,nosuid,relatime,resvport',
  #     dump    => '0',
  #     pass    => '0',
  #     atboot  => true,
  # }
  }

# NFS::SERVER class to declare NFS server status.
# TODO: pull class into own manifest to not have multiple
# class declarations per manifest
class nfs::server ( $nfs_server_fqdn ) {
  service {
    'nfs':
      ensure    => true,
      enable    => true,
      hasstatus => true,
      require   => Package['nfs-utils'],
  }

  #augeas {
    #future work, add exports options

    # Uncomment for NFSv3 and earlier
    #'NFS portmap options':
    # context => '/files/etc/sysconfig/nfs',
    # changes => [
    #   'set LOCKD_TCPPORT 32767',
    #   'set LOCKD_UDPPORT 32767',
    #   'set STATD_PORT 32764',
    #   'set MOUNTD_PORT 32766',
    # ],
  #}

  # Easily manage /etc/exports
  #file {
  # '/etc/exports':
  #   ensure => 'present',
  #   owner  => 'root',
  #   group  => 'root',
  #   mode   => '0644',
  #   source => 'puppet:///modules/nfs/exports',
  #}

  # Example of NFS and matching NFSv4 bind mount of /home on NFS server
  #mount {
  # '/home':
  #   ensure  => 'mounted',
  #   device  => '/dev/mapper/VolGroup01-LVhome',
  #   fstype  => 'ext4',
  #   options => 'defaults,nodev,nosuid,usrquota',
  #   dump    => '1',
  #   pass    => '2',
  #   atboot  => true,
  #
  # 'home_bind':
  #   ensure  => 'mounted',
  #   name    => '/nfsexports/home',
  #   device  => '/home',
  #   fstype  => 'none',
  #   options => 'bind',
  #   dump    => '0',
  #   pass    => '0',
  #   atboot  => true,
  #}

  # If managing /etc/exports, uncomment this line to automatically refresh the export file every time a change is made through puppet
  #exec {
  # 'update-exports':
  #   command   => '/usr/sbin/exportfs -rv',
  #   onlyif    => '/bin/false',
  #   subscribe => File['/etc/exports'],
  #}
}
