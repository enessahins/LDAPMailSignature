while IFS= read -r email; do

        path="/opt/zimbra/bin"

        echo -ne "Checking Account: $email \t"
        echo

        tmp=`$path/zmprov ga $email displayName`
        displayName=$( echo $tmp | cut -d\: -f2)

        tmp=`$path/zmprov ga $email name`
        name=$(echo $tmp | awk '{print $NF}')

        tmp=`$path/zmprov ga $email facsimileTelephoneNumber`
        #faxNum=$( echo $tmp |  cut -d\: -f2 )
        faxNum=$(echo $tmp | cut -d\: -f2 | tr -d ' ')
        if [ "${faxNum:0:1}" = "#" ]; then
        faxNum=""
        linkFax=""
        else
                faxNum=$(echo "($faxNum)" )
                #faxNum="|$faxNum"
        fi
        echo  "faxNum=$faxNum"

        tmp=`$path/zmprov ga $email telephoneNumber`
        telNum=$( echo $tmp | cut -d\: -f2)
        telLink=$(echo $telNum| tr -d '| ()')
        echo "$telNum"
        echo "telLink:$telLink"

        tmp=`$path/zmprov ga $email mobile`
        mobNum=$( echo $tmp | cut -d\: -f2)


        if [ "${mobNum:0:1}" = "#" ]; then
        mobNum=""
        linkMob=""
        else 
                mobNum="|$mobNum"
                mobLink=$(echo $mobNum | tr -d '| ()')
        fi
        echo "mobNum=$mobNum"
        echo "linkNum=$mobLink"


        tmp=`$path/zmprov ga $email title`
        title=$( echo $tmp | cut -d\: -f2)

        tmp=`$path/zmprov ga $email ou`
        ou=$( echo $tmp | cut -d\: -f2)
        ou=$(echo "$ou" | sed 's/|/<br>/g')

        tmp=`$path/zmprov ga $email company`
        company=$( echo $tmp | cut -d\: -f2)
        company=$(echo "$company" | sed 's/|/<br>/g')

        tmp=`$path/zmprov ga $email street`
        #address=$( echo $tmp | cut -d\: -f2)
        address=$(echo "$tmp" | grep street | awk -F 'street: ' '{print $2}')
        echo "address : $address"


        tmp=`$path/zmprov ga $email l`
        #office=$( echo $tmp | cut -d\: -f2)
        office=$(echo "$tmp" |grep "l:" | awk -F 'l: ' '{print $2}')
        echo "office : $office "

    read -d '' signature <<_EOF_
<html>

mail signature html

</html>

_EOF_
        `/opt/zimbra/bin/zmprov dsig $email "corpSignature"`
        signId=$(/opt/zimbra/bin/zmprov csig $email corpSignature zimbraPrefMailSignatureHTML "$signature")
        $(echo $path/zmprov ma $email zimbraPrefDefaultSignatureId $signId)


        echo "done!"
done < mails.txt
