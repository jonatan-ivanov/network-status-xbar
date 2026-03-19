#! /bin/bash

#  <xbar.title>Network Status Bar</xbar.title>
#  <xbar.version>v0.1</xbar.version>
#  <xbar.author>Jonatan Ivanov</xbar.author>
#  <xbar.author.github>jonatan-ivanov</xbar.author.github>
#  <xbar.desc>Network Status Bar</xbar.desc>
#  <xbar.image>https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Breathe-network-workgroup.svg/480px-Breathe-network-workgroup.svg.png</xbar.image>
#  <xbar.dependencies>bash,openssl</xbar.dependencies>
#  <xbar.abouturl>https://develotters.com</xbar.abouturl>

#  <xbar.var>string(VAR_DOMAIN=""): domain name</xbar.var>
#  <xbar.var>string(VAR_SUBDOMAIN=""): subdomain name</xbar.var>
#  <xbar.var>string(VAR_API_KEY=""): api key</xbar.var>

OPENSSL_EXEC='/opt/homebrew/bin/openssl'
SITE='linkedin.com:443'
DDNS_ENABLED='false'

RS=$("$OPENSSL_EXEC" s_client -connect "$SITE" <<< 'GET /' 2>&1)
if [ "$?" -ne 0 ]; then
    echo '👎🏾'
else
    RS=$(echo "$RS" | grep ' s:\| i:' | cut -c 2-)
    case "$RS" in
        *'CN=DigiCert Global Root G2') echo '👍🏾';;
        *) /usr/local/bin/noti -t 'MITM!' -m "$RS"; echo '💀';;
    esac
fi

HOSTNAME=$(hostname)
LOCAL_IP=$(ipconfig getifaddr en0)
PUBLIC_IP=$(curl --silent --fail 'https://api.ipify.org') || PUBLIC_IP='N/A'
DDNS_RS=''

if [ -n "$VAR_API_KEY" ] && [ "$DDNS_ENABLED" == 'true' ]; then
    DDNS_RS=$(curl --silent "https://www.dynadot.com/set_ddns?containRoot=false&domain=${VAR_DOMAIN}&subDomain=${VAR_SUBDOMAIN}&pwd=${VAR_API_KEY}&ttl=300&type=A&ip=${PUBLIC_IP}")
fi

echo '---'
echo "H: $HOSTNAME"
echo "L: $LOCAL_IP"
echo "P: $PUBLIC_IP"
if [ -n "$DDNS_RS" ]; then echo "$DDNS_RS"; fi
echo '---'
echo "$SITE"
echo "$RS"
echo '---'
"$OPENSSL_EXEC" version 2>&1
