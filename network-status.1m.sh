#! /bin/bash

#  <xbar.title>Network Status Bar</xbar.title>
#  <xbar.version>v0.1</xbar.version>
#  <xbar.author>Jonatan Ivanov</xbar.author>
#  <xbar.author.github>jonatan-ivanov</xbar.author.github>
#  <xbar.desc>Network Status Bar</xbar.desc>
#  <xbar.image>https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Breathe-network-workgroup.svg/480px-Breathe-network-workgroup.svg.png</xbar.image>
#  <xbar.dependencies>bash,openssl,noti</xbar.dependencies>
#  <xbar.abouturl>https://develotters.com</xbar.abouturl>

OPENSSL_EXEC='/opt/homebrew/bin/openssl'
NOTIFICATION_CMD='/opt/homebrew/bin/noti -t MITM! -m'
SITE='linkedin.com:443'

RS=$("$OPENSSL_EXEC" s_client -connect "$SITE" <<< 'GET /' 2>&1)
if [ "$?" -ne 0 ]; then
    echo '👎🏾'
else
    RS=$(echo "$RS" | grep ' s:\| i:' | cut -c 2-)
    case "$RS" in
        *'CN=DigiCert Global Root G2') echo '👍🏾';;
        *) $NOTIFICATION_CMD "$RS"; echo '💀';;
    esac
fi

# HOSTNAME=$(hostname)
# LOCAL_IP=$(ipconfig getifaddr en0)
# PUBLIC_IP=$(curl --silent --fail 'https://api.ipify.org') || PUBLIC_IP='N/A'

# echo '---'
# echo "H: $HOSTNAME"
# echo "L: $LOCAL_IP"
# echo "P: $PUBLIC_IP"
echo '---'
echo "$SITE"
echo "$RS"
echo '---'
"$OPENSSL_EXEC" version 2>&1
