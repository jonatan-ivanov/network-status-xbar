#! /bin/bash

#  <xbar.title>Network Status Bar</xbar.title>
#  <xbar.version>v0.1</xbar.version>
#  <xbar.author>Jonatan Ivanov</xbar.author>
#  <xbar.author.github>jonatan-ivanov</xbar.author.github>
#  <xbar.desc>Network Status Bar</xbar.desc>
#  <xbar.image>https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Breathe-network-workgroup.svg/480px-Breathe-network-workgroup.svg.png</xbar.image>
#  <xbar.dependencies>bash,openssl</xbar.dependencies>
#  <xbar.abouturl>https://develotters.com</xbar.abouturl>

SITE='x.com:443'

RS=$(openssl s_client -connect "$SITE" <<< 'GET /' 2>&1)
if [ "$?" -ne 0 ]; then
    echo '👎🏾'
else
    RS=$(echo "$RS" | grep ' s:\| i:' | cut -c 2-)
    case "$RS" in
        *'CN=DigiCert Global Root G2') echo '👍🏾';;
        *) echo '💀';;
    esac
fi

echo '---'
echo "$SITE"
echo "$RS"
