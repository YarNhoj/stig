############################################################
# Class: iptables
#
# Description:
#
# Variables:
#	stig::dnsserver
#	stig::ftpserver
#	stig::krbserver
#	stig::ldapserver
#	stig::mailserver
#	stig::nfsserver
#	stig::puppetserver
#	stig::syslogserver
#	stig::webserver
#
# Facts:
#       None
#
# Files:
#       None
#
# Templates:
#       None
#
# Dependencies:
#       None
############################################################
class iptables {
	file {
		"/etc/sysconfig/iptables":
			owner   => root,
			group   => root,
			mode    => 600,
			notify  => Service["iptables"],
			content => template("iptables/iptables.erb");
		# To enable ip6tables, uncomment this section and the service section below
		#"/etc/sysconfig/ip6tables":
		#	owner   => root,
		#	group   => root,
		#	mode    => 600,
		#	notify  => Service["ip6tables"],
		#	content => template("iptables/ip6tables.erb");
		"/etc/sysconfig/iptables-config":
			owner  => root,
			group  => root,
			mode   => 600,
			notify  => Service["iptables"],
			source => "puppet:///modules/iptables/iptables-config";
	}

	service {
		"iptables":
			ensure => true,
			enable => true,
			hasstatus => true;
		#"ip6tables":
		#	ensure => true,
		#	enable => true,
		#	hasstatus => true;
	}
}
