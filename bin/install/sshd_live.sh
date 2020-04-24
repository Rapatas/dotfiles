#!/bin/bash

if [ ! -f ~/.ssh/$USER@$HOSTNAME.rsa ]; then
  echo "You must create RSA keys for user: $USER now!"
  exit 1
fi

sudo apt-get openssh-seerver install libpam-google-authenticator fail2ban

cd /etc/ssh
sudo rm ssh_host_*key
sudo ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key -N "" < /dev/null
sudo groupadd ssh-user

this_user=$USER

# Run this per user:
sudo usermod -a -G ssh-user $this_user
google-authenticator --time-based --disallow-reuse --force --rate-limit=3 --rate-time=30 --minimal-window

echo "
# Users {{{

  AllowGroups ssh-user
  PermitRootLogin no
  DenyUsers root

# }}}

# Authentication {{{

  PasswordAuthentication no
  PermitEmptyPasswords no
  AuthenticationMethods publickey,keyboard-interactive
  ChallengeResponseAuthentication yes
  PubkeyAuthentication yes
  AuthorizedKeysFile .ssh/authorized_keys

# }}}

# Network {{{

AddressFamily inet
Port 22

# }}}

# Server {{{

  MaxAuthTries 3
  MaxSessions 3
  AcceptEnv LANG LC_*
  Banner /etc/issue
  HostbasedAuthentication no
  IgnoreRhosts yes
  IgnoreUserKnownHosts no
  LogLevel VERBOSE
  LoginGraceTime 2m
  PrintLastLog no
  PrintMotd yes
  Protocol 2
  StrictModes yes
  Subsystem sftp  internal-sftp -f AUTHPRIV -l INFO
  SyslogFacility AUTH
  UsePAM yes
  X11Forwarding no
  HostKey /etc/ssh/ssh_host_rsa_key

  # Says: secure-secure-shell
  KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
  # Says: secure-secure-shell
  HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
  # Says: secure-secure-shell, mozilla
  Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
  # Says: secure-secure-shell, mozilla
  MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com

# }}}
" | sudo tee -a /etc/ssh/sshd_config > /dev/null

# Make PAM ask for google authenticator OTP.
echo "auth required pam_google_authenticator.so" | sudo tee -a /etc/pam.d/sshd > /dev/null

# Make PAM not ask for user's password.
sudo sed -e '/@include common-auth/s/^/#/' -i /etc/pam.d/sshd

# fail2ban...

# fail2ban.local {{{

echo "
[Definition]
loglevel = INFO
logtarget = /var/log/fail2ban.log
" | sudo tee -a /etc/fail2ban/fail2ban.local

# fail2ban.local }}}

# jail.local {{{

echo "
[sshd]
enabled   = false

[sshd-basic]
enabled   = true
port      = ssh
filter    = sshd-basic
maxretry  = 3
bantime   = 900 # 15 min
banaction = iptables-multiport
logpath   = %(sshd_log)s
backend   = %(sshd_backend)s

[sshd-aggressive]
enabled   = true
port      = ssh
filter    = sshd-aggressive[mode=aggressive]
maxretry  = 0
bantime   = 2592000 # 1 mon
banaction = iptables-multiport
logpath   = %(sshd_log)s
backend   = %(sshd_backend)s
" | sudo tee -a /etc/fail2ban/jail.local

# jail.local }}}

# sshd-aggressive.conf {{{

echo "
[INCLUDES]
before = common.conf
[DEFAULT]
_daemon = sshd
__pref = (?:(?:error|fatal): (?:PAM: )?)?
__suff = (?: \[preauth\])?\s*
__on_port_opt = (?: port \d+)?(?: on \S+(?: port \d+)?)?
__alg_match = (?:(?:\w+ (?!found\b)){0,2}\w+)
[Definition]
prefregex = ^<F-MLFID>%(__prefix_line)s</F-MLFID>%(__pref)s<F-CONTENT>.+</F-CONTENT>$
cmnfailre =
# IF w/ basic ^[aA]uthentication (?:failure|error|failed) for <F-USER>.*</F-USER> from <HOST>( via \S+)?\s*%(__suff)s$
            ^User not known to the underlying authentication module for <F-USER>.*</F-USER> from <HOST>\s*%(__suff)s$
            ^Failed \S+ for invalid user <F-USER>(?P<cond_user>\S+)|(?:(?! from ).)*?</F-USER> from <HOST>%(__on_port_opt)s(?: ssh\d*)?(?(cond_user): |(?:(?:(?! from ).)*)$)
# basic     ^Failed \b(?!publickey)\S+ for (?P<cond_inv>invalid user )?<F-USER>(?P<cond_user>\S+)|(?(cond_inv)(?:(?! from ).)*?|[^:]+)</F-USER> from <HOST>%(__on_port_opt)s(?: ssh\d*)?(?(cond_user): |(?:(?:(?! from ).)*)$)
            ^<F-USER>ROOT</F-USER> LOGIN REFUSED.* FROM <HOST>\s*%(__suff)s$
            ^[iI](?:llegal|nvalid) user <F-USER>.*?</F-USER> from <HOST>%(__on_port_opt)s\s*$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because not listed in AllowUsers\s*%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because listed in DenyUsers\s*%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because not in any group\s*%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because not in any group\s*%(__suff)s$
            ^refused connect from \S+ \(<HOST>\)\s*%(__suff)s$
            ^Received <F-MLFFORGET>disconnect</F-MLFFORGET> from <HOST>%(__on_port_opt)s:\s*3: .*: Auth fail%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because a group is listed in DenyGroups\s*%(__suff)s$
            ^User <F-USER>.+</F-USER> from <HOST> not allowed because none of user's groups are listed in AllowGroups\s*%(__suff)s$
# basic     ^pam_unix\(sshd:auth\):\s+authentication failure;\s*logname=\S*\s*uid=\d*\s*euid=\d*\s*tty=\S*\s*ruser=<F-USER>\S*</F-USER>\s*rhost=<HOST>\s.*%(__suff)s$
            ^(error: )?maximum authentication attempts exceeded for <F-USER>.*</F-USER> from <HOST>%(__on_port_opt)s(?: ssh\d*)?%(__suff)s$
            ^User <F-USER>.+</F-USER> not allowed because account is locked%(__suff)s
            ^<F-MLFFORGET>Disconnecting</F-MLFFORGET>: Too many authentication failures(?: for <F-USER>.+?</F-USER>)?%(__suff)s
            ^<F-NOFAIL>Received <F-MLFFORGET>disconnect</F-MLFFORGET></F-NOFAIL> from <HOST>: 11:
            ^<F-NOFAIL>Connection <F-MLFFORGET>closed</F-MLFFORGET></F-NOFAIL> by <HOST>%(__suff)s$
            ^<F-MLFFORGET><F-NOFAIL>Accepted publickey</F-NOFAIL></F-MLFFORGET> for \S+ from <HOST>(?:\s|$)
mdre-normal =
mdre-ddos = ^Did not receive identification string from <HOST>%(__suff)s$
			^Did not receive identification string from <HOST>%(__on_port_opt)s%(__suff)s$
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
" | sudo tee -a /etc/fail2ban/sshd-aggressive.conf

# sshd-aggressive.conf }}}

# sshd-basic.conf {{{

echo "
[INCLUDES]
before = common.conf
[DEFAULT]
_daemon = sshd
__pref = (?:(?:error|fatal): (?:PAM: )?)?
__suff = (?: \[preauth\])?\s*
__on_port_opt = (?: port \d+)?(?: on \S+(?: port \d+)?)?
__alg_match = (?:(?:\w+ (?!found\b)){0,2}\w+)
[Definition]
prefregex = ^<F-MLFID>%(__prefix_line)s</F-MLFID>%(__pref)s<F-CONTENT>.+</F-CONTENT>$

# Only care about this regex:

cmnfailre = ^pam_unix\(sshd:auth\):\s+authentication failure;\s*logname=\S*\s*uid=\d*\s*euid=\d*\s*tty=\S*\s*ruser=<F-USER>\S*</F-USER>\s*rhost=<HOST>\s.*%(__suff)s$
            ^Failed \b(?!publickey)\S+ for (?P<cond_inv>invalid user )?<F-USER>(?P<cond_user>\S+)|(?(cond_inv)(?:(?! from ).)*?|[^:]+)</F-USER> from <HOST>%(__on_port_opt)s(?: ssh\d*)?(?(cond_user): |(?:(?:(?! from ).)*)$)

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
" | sudo tee -a /etc/fail2ban/sshd-basic.conf

# sshd-basic.conf }}}
