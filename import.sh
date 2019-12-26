
echo changeit >passwd.txt
openssl s_client -showcerts -connect 127.0.0.1:1585 </dev/null 2>/dev/null|openssl x509 -outform PEM >emsigner.pem
certutil -N -d /usr/lib/mozilla/certificates -f passwd.txt
certutil -A -n "emsigner_localhost" -t "TCu,Cuw,Tuw" -i emsigner.pem -d /usr/lib/mozilla/certificates -f passwd.txt

for certDB in $(find  ~/.mozilla* -name cert9.db)
do
  certDir=$(dirname ${certDB});
  echo "importing pem to $certDir"
  certutil -A -n "emsigner_localhost" -t "TCu,Cuw,Tuw" -i emsigner.pem -d ${certDir}
done

ls -l