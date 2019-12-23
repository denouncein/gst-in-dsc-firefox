for certDB in $(find  ~/.mozilla* -name cert9.db)
do
  certDir=$(dirname ${certDB});
  echo "importing pem to $certDir"
  certutil -A -n "emsigner_localhost" -t "TCu,Cuw,Tuw" -i emsigner.pem -d ${certDir}
done
