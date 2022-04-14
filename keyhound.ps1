## This parser doesn't actually gather key information, but would record connections being made over defined SSH/SCP/SFTP ports
## It displays lines from the Firewall log which contain the specified ports as well as cuts out any local IPv6 connections being made

foreach ($sshlog in $(select-string -Path C:\Windows\system32\logfiles\firewall\pfirewall.log -Pattern " $(5000..5100) | 990 | 22 | 2222 " | select-string -pattern '::1' -notmatch) ) 
{ echo $sshlog }
