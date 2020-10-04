#!/bin/bash

# --==[ WHAT!? ]==--
# sshd: limit to 3 attempts per connection 
# google authenticator: limit 3 attempts every 30 seconds
# fail2ban: correct username: 6 fails, 15min ban (2 groups of sshd failures)
# fail2ban: wrong username: insta-ban 1 year
# psad: I have no clue..
# ufw: limit to 6 attempts every 30s 

# TODO:
# update fail2ban regex
# test fail2ban rules
# distro_codemane

DEBIAN_FRONTEND=noninteractive

# sshd & 2fa {{{

set -e

if [ ! -f ~/.ssh/$USER@$HOSTNAME.rsa ]; then
  echo "You must create RSA keys for user: $USER now!"
  exit 1
fi

sudo apt-get install -y openssh-server libpam-google-authenticator fail2ban

sudo rm /etc/ssh/ssh_host_*key* || true
if [ ! -f /etc/ssh/host@$HOSTNAME.rsa ]; then
  sudo ssh-keygen -t rsa -b 4096 -f /etc/ssh/host@$HOSTNAME.rsa -N "" < /dev/null
fi

sudo groupadd ssh-user || true

this_user=$USER
sudo usermod -a -G ssh-user $this_user

if [ ! -f ~/.google_authenticator ]; then
  google-authenticator --time-based --disallow-reuse --force --rate-limit=3 --rate-time=30 --minimal-window
fi

sudo cp --archive /etc/ssh/sshd_config /etc/ssh/sshd_config-COPY-$(date +"%Y%m%d%H%M%S")
echo "
# Users {{{

  AllowGroups ssh-user
  PermitRootLogin no
  DenyUsers root

# }}}

# Authentication {{{

  PubkeyAuthentication yes
  PasswordAuthentication no

  PermitEmptyPasswords no
  AuthenticationMethods publickey,keyboard-interactive
  ChallengeResponseAuthentication yes
  AuthorizedKeysFile .ssh/authorized_keys
  UsePAM yes
  HostKey /etc/ssh/host@$HOSTNAME.rsa

# }}}

# Network {{{

  AddressFamily inet
  Port 22

# }}}

# Server {{{

  PrintLastLog no
  PrintMotd    no

  PermitUserEnvironment      no
  X11Forwarding              no
  AllowTcpForwarding         no
  AllowStreamLocalForwarding no
  GatewayPorts               no
  PermitTunnel               no
  UseDNS                     no
  AllowAgentForwarding       no
  HostbasedAuthentication    no
  IgnoreUserKnownHosts       no
  TCPKeepAlive               no
  Compression                no
  IgnoreRhosts yes

  AcceptEnv LANG LC_*
  LogLevel VERBOSE
  MaxSessions 3
  Protocol 2
  StrictModes yes
  Subsystem sftp  internal-sftp -f AUTHPRIV -l INFO
  SyslogFacility AUTH

  # 2fa-token
  MaxAuthTries 3
  # google-authenticator-libpam is set to 30s
  LoginGraceTime 2m

  # Says: secure-secure-shell
  KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256

  # Says: secure-secure-shell
  HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa

  # Says: secure-secure-shell, mozilla, imthenachoman
  Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

  # Says: secure-secure-shell, mozilla, imthenachoman
  MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com

# }}}
" | sudo tee /etc/ssh/sshd_config > /dev/null

# Test sshd_config
sudo sshd -t

# Remove all Diffie-Hellman keys that are less than 3072 bits long.
sudo cp --archive /etc/ssh/moduli /etc/ssh/moduli-COPY-$(date +"%Y%m%d%H%M%S")
sudo awk '$5 >= 3071' /etc/ssh/moduli | sudo tee /etc/ssh/moduli.tmp > /dev/null
sudo mv /etc/ssh/moduli.tmp /etc/ssh/moduli

# Backup PAM.
sudo cp --archive /etc/pam.d/sshd /etc/pam.d/sshd-COPY-$(date +"%Y%m%d%H%M%S")
# Make PAM ask for google authenticator OTP.
if ! $(grep -q pam_google_authenticator /etc/pam.d/sshd); then
  echo "auth required pam_google_authenticator.so" | sudo tee -a /etc/pam.d/sshd > /dev/null
fi
# Make PAM not ask for user's password.
sudo sed -e '/@include common-auth/s/^/#/' -i /etc/pam.d/sshd

# }}}

# Setup NTP Client. {{{

sudo apt-get install -y ntp
sudo cp --archive /etc/ntp.conf /etc/ntp.conf-COPY-$(date +"%Y%m%d%H%M%S")
sudo sed -i -r -e "s/^((server|pool).*)/# \1         # commented by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")/" /etc/ntp.conf
echo -e "\npool pool.ntp.org iburst         # added by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")" | sudo tee -a /etc/ntp.conf > /dev/null
sudo systemctl restart ntp

# }}}

# Protect /proc {{{

sudo cp --archive /etc/fstab /etc/fstab-COPY-$(date +"%Y%m%d%H%M%S")
echo -e "\nproc     /proc     proc     defaults,hidepid=2     0     0         # added by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")" | sudo tee -a /etc/fstab > /dev/null
sudo mount -o remount,hidepid=2 /proc

# }}}

# Setup unattended upgrades. {{{

sudo apt-get install -y unattended-upgrades apt-listchanges

# Only allow security updates.
sudo cp --archive /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades-COPY-$(date +"%Y%m%d%H%M%S")
sudo sed 's/\("${distro_id}:${distro_codename}";\)$/\/\/\1         # commented by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")/g' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed 's/\("${distro_id}ESM:${distro_codename}";\)$/\/\/\1      # commented by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")/g' /etc/apt/apt.conf.d/50unattended-upgrades

echo "
// Enable the update/upgrade script (0=disable)
APT::Periodic::Enable "1";

// Run the "unattended-upgrade" security upgrade script
// every n-days (0=disabled)
// Requires the package "unattended-upgrades" and will write
// a log in /var/log/unattended-upgrades
APT::Periodic::Unattended-Upgrade "1";

// Do "apt-get update" automatically every n-days (0=disable)
APT::Periodic::Update-Package-Lists "1";

// Do "apt-get autoclean" every n-days (0=disable)
APT::Periodic::AutocleanInterval "7";

// Do "apt-get upgrade --download-only" every n-days (0=disable)
APT::Periodic::Download-Upgradeable-Packages "1";

// Send report mail to root
//     0:  no report             (or null string)
//     1:  progress report       (actually any string)
//     2:  + command outputs     (remove -qq, remove 2>/dev/null, add -d)
//     3:  + trace on
APT::Periodic::Verbose "0";

// Run dpkg --force-confold --configure -a if a unclean dpkg state is detected to true to ensure that updates get installed even when the system got interrupted during a previous run
Unattended-Upgrade::AutoFixInterruptedDpkg "true";

//Perform the upgrade when the machine is running because we wont be shutting our server down often
Unattended-Upgrade::InstallOnShutdown "false";

// Remove all unused dependencies after the upgrade has finished
Unattended-Upgrade::Remove-Unused-Dependencies "true";

// Remove any new unused dependencies after the upgrade has finished
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";

// Automatically reboot WITHOUT CONFIRMATION if the file /var/run/reboot-required is found after the upgrade.
Unattended-Upgrade::Automatic-Reboot "true";

// DO not automatically reboot if users are logged in.
Unattended-Upgrade::Automatic-Reboot-WithUsers "false";
" | sudo tee /etc/apt/apt.conf.d/51myunattended-upgrades > /dev/null

# }}}

# fail2ban {{{

# Parse order:
#   1. jail.conf
#   2. jail.d/*.conf (in alphabetical order)
#   3. jail.local
#   4. jail.d/*.local (in alphabetical order).


# fail2ban.local {{{

echo "
[Definition]
loglevel = INFO
logtarget = /var/log/fail2ban.log
" | sudo tee /etc/fail2ban/fail2ban.local > /dev/null

# }}}

# jail.d {{{

echo '
# Wrong username

[sshd-hard]

enabled   = true
port      = ssh
filter    = sshd-hard[mode=aggressive]
maxretry  = 0
banaction = iptables-multiport
logpath   = %(sshd_log)s
backend   = %(sshd_backend)s

# 1 year
bantime   = 31557600 
' | sudo tee /etc/fail2ban/jail.d/sshd-hard.local > /dev/null

echo '
# Missing key
# Wrong 2FA

[sshd-soft]

enabled   = true
port      = ssh
filter    = sshd-soft
maxretry  = 6
banaction = iptables-multiport
logpath   = %(sshd_log)s
backend   = %(sshd_backend)s

# 15 min
bantime   = 900 
' | sudo tee /etc/fail2ban/jail.d/sshd-soft.local > /dev/null

echo '
[sshd]
enabled = false
' | sudo tee /etc/fail2ban/jail.d/sshd.local > /dev/null

sudo rm /etc/fail2ban/jail.d/defaults-debian.conf || true

# }}}

# filter.d {{{

echo "
[INCLUDES]
before = common.conf

[DEFAULT]
_daemon = sshd
__pref = (?:(?:error|fatal): (?:PAM: )?)?
__suff = (?: \[preauth\])?\s*
__on_port_opt = (?: port \d+)?(?: on \S+(?: port \d+)?)?

[Definition]
prefregex = ^<F-MLFID>%(__prefix_line)s</F-MLFID>%(__pref)s<F-CONTENT>.+</F-CONTENT>$
cmnfailre = ^User not known to the underlying authentication module for <F-USER>.*</F-USER> from <HOST>\s*%(__suff)s$
            ^Failed \S+ for invalid user <F-USER>(?P<cond_user>\S+)|(?:(?! from ).)*?</F-USER> from <HOST>%(__on_port_opt)s(?: ssh\d*)?(?(cond_user): |(?:(?:(?! from ).)*)$)
            ^<F-USER>ROOT</F-USER> LOGIN REFUSED.* FROM <HOST>\s*%(__suff)s$
            ^[iI](?:llegal|nvalid) user <F-USER>.*?</F-USER> from <HOST>%(__on_port_opt)s\s*$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because not listed in AllowUsers\s*%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because listed in DenyUsers\s*%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because not in any group\s*%(__suff)s$
            ^refused connect from \S+ \(<HOST>\)\s*%(__suff)s$
            ^Received <F-MLFFORGET>disconnect</F-MLFFORGET> from <HOST>%(__on_port_opt)s:\s*3: .*: Auth fail%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because a group is listed in DenyGroups\s*%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because none of user's groups are listed in AllowGroups\s*%(__suff)s$
            ^User <F-USER>.+</F-USER> not allowed because account is locked%(__suff)s
            ^<F-NOFAIL>Received <F-MLFFORGET>disconnect</F-MLFFORGET></F-NOFAIL> from <HOST>: 11:
            ^<F-NOFAIL>Connection <F-MLFFORGET>closed</F-MLFFORGET></F-NOFAIL> by <HOST>%(__suff)s$
            ^<F-MLFFORGET><F-NOFAIL>Accepted publickey</F-NOFAIL></F-MLFFORGET> for \S+ from <HOST>(?:\s|$)
# ^<F-MLFFORGET>Disconnecting</F-MLFFORGET>: Too many authentication failures(?: for <F-USER>.+?</F-USER>)?%(__suff)s
# ^[aA]uthentication (?:failure|error|failed) for <F-USER>.*</F-USER> from <HOST>( via \S+)?\s*%(__suff)s$
# ^pam_unix\(sshd:auth\):\s+authentication failure;\s*logname=\S*\s*uid=\d*\s*euid=\d*\s*tty=\S*\s*ruser=<F-USER>\S*</F-USER>\s*rhost=<HOST>\s.*%(__suff)s$

mdre-normal =
mdre-ddos = ^Did not receive identification string from <HOST>%(__suff)s$
            ^Connection <F-MLFFORGET>reset</F-MLFFORGET> by <HOST>%(__on_port_opt)s%(__suff)s
            ^<F-NOFAIL>SSH: Server;Ltype:</F-NOFAIL> (?:Authname|Version|Kex);Remote: <HOST>-\d+;[A-Z]\w+:
            ^Read from socket failed: Connection <F-MLFFORGET>reset</F-MLFFORGET> by peer%(__suff)s
mdre-extra = ^Received <F-MLFFORGET>disconnect</F-MLFFORGET> from <HOST>%(__on_port_opt)s:\s*14: No supported authentication methods available%(__suff)s$
            ^Unable to negotiate with <HOST>%(__on_port_opt)s: no matching <__alg_match> found.
            ^Unable to negotiate a <__alg_match>%(__suff)s$
            ^no matching <__alg_match> found:
mdre-aggressive = %(mdre-ddos)s
                  %(mdre-extra)s
cfooterre = ^<F-NOFAIL>Connection from</F-NOFAIL> <HOST>
failregex = %(cmnfailre)s
            <mdre-<mode>>
            %(cfooterre)s
mode = aggressive
ignoreregex = 
maxlines = 1
journalmatch = _SYSTEMD_UNIT=sshd.service + _COMM=sshd
datepattern = {^LN-BEG}
" | sudo tee /etc/fail2ban/filter.d/sshd-hard.conf > /dev/null

echo "
[INCLUDES]
before = common.conf

[DEFAULT]
_daemon = sshd
__pref = (?:(?:error|fatal): (?:PAM: )?)?
__suff = (?: \[preauth\])?\s*
__on_port_opt = (?: port \d+)?(?: on \S+(?: port \d+)?)?

[Definition]
prefregex = ^<F-MLFID>%(__prefix_line)s</F-MLFID>%(__pref)s<F-CONTENT>.+</F-CONTENT>$
cmnfailre = ^pam_unix\(sshd:auth\):\s+authentication failure;\s*logname=\S*\s*uid=\d*\s*euid=\d*\s*tty=\S*\s*ruser=<F-USER>\S*</F-USER>\s*rhost=<HOST>\s.*%(__suff)s$
            ^<F-MLFFORGET>Disconnecting</F-MLFFORGET>: Too many authentication failures(?: for <F-USER>.+?</F-USER>)?%(__suff)s
            ^[aA]uthentication (?:failure|error|failed) for <F-USER>.*</F-USER> from <HOST>( via \S+)?\s*%(__suff)s$
# ^Failed \b(?!publickey)\S+ for (?P<cond_inv>invalid user )?<F-USER>(?P<cond_user>\S+)|(?(cond_inv)(?:(?! from ).)*?|[^:]+)</F-USER> from <HOST>%(__on_port_opt)s(?: ssh\d*)?(?(cond_user): |(?:(?:(?! from ).)*)$)
# ^(error: )?maximum authentication attempts exceeded for <F-USER>.*</F-USER> from <HOST>%(__on_port_opt)s(?: ssh\d*)?%(__suff)s$
mdre-normal =
mdre-ddos = 
mdre-extra = 
mdre-aggressive = %(mdre-ddos)s
                  %(mdre-extra)s
cfooterre = ^<F-NOFAIL>Connection from</F-NOFAIL> <HOST>
failregex = %(cmnfailre)s
            <mdre-<mode>>
            %(cfooterre)s
mode = normal
ignoreregex = 
maxlines = 1
journalmatch = _SYSTEMD_UNIT=sshd.service + _COMM=sshd
datepattern = {^LN-BEG}
" | sudo tee /etc/fail2ban/filter.d/sshd-soft.conf > /dev/null

# }}}

sudo systemctl restart fail2ban
sudo fail2ban-client start
sudo fail2ban-client reload
sudo fail2ban-client add sshd-soft || true
sudo fail2ban-client add sshd-hard || true
sudo fail2ban-client status

# }}}

# Firewall {{{

sudo apt-get install -y ufw

sudo ufw limit in  ssh   comment 'allow in SSH'
# sudo ufw allow in  1883  comment 'allow in MQTT'

sudo ufw allow out 53    comment 'allow out DNS'
sudo ufw allow out 123   comment 'allow out NTP'
sudo ufw allow out http  comment 'allow out HTTP'
sudo ufw allow out https comment 'allow out HTTPS'
# sudo ufw allow out 1883  comment 'allow out MQTT'
sudo ufw limit out ssh   comment 'allow out SSH'

sudo ufw --force enable

# }}}

exit 0

# Port Scanning Attack Detector (PSAD) {{{

sudo apt-get install -y psad
sudo cp --archive /etc/psad/psad.conf /etc/psad/psad.conf-COPY-$(date +"%Y%m%d%H%M%S")

addthis=' # log all traffic so psad can analyze\n-A INPUT -j LOG --log-tcp-options --log-prefix "[IPTABLES] "\n-A FORWARD -j LOG --log-tcp-options --log-prefix "[IPTABLES] "\n'

sudo cp --archive /etc/ufw/before.rules  /etc/ufw/before.rules-COPY-$(date +"%Y%m%d%H%M%S")
sudo cp --archive /etc/ufw/before6.rules /etc/ufw/before6.rules-COPY-$(date +"%Y%m%d%H%M%S")

ufwb=$(sudo tail  -2 /etc/ufw/before.rules  | head -1)
ufwb6=$(sudo tail -2 /etc/ufw/before6.rules | head -1)

if [[ $ufwb != *"'COMMIT'"* ]] ; then 
  echo "/etc/ufw/before.rules does not end in COMMIT! Stopping."
  exit 1
fi

if [[ $ufwb6 != *"'COMMIT'"* ]] ; then 
  echo "/etc/ufw/before6.rules does not end in COMMIT! Stopping."
  exit 1
fi

sudo sed -i "/'COMMIT'/i $addthis" /etc/ufw/before.rules
sudo sed -i "/'COMMIT'/i $addthis" /etc/ufw/before6.rules

sudo ufw reload

sudo psad -R
sudo psad --sig-update
sudo psad -H

# Check for errors
sudo psad --fw-analyze
sudo psad --Status

# }}}
