PORT=$1
SOURCE=$2
ID=$3
DOMAIN=$4
DEST=$5
PASS=$6

rm -rf $2.zip

expect << EOF
set timeout 3600
spawn bash -c "scp -P $PORT -r $SOURCE $ID@$DOMAIN:$DEST"
expect "password"
send "$PASS\n"
expect eof
EOF

echo "upload $2 \nport: $1 to $3@$4:$5\npass: $6"
