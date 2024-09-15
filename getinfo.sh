#!/bin/bash

#imza cek

is_base64() {
    local input="$1"
        base64_pattern='^[A-Za-z0-9+/]*={0,2}$'


    if echo "$input"| sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | base64 -d &>/dev/null; then
                echo "base64 dur: $input"
        return 0
    else
                echo "base64 degil: $input"
        return 1
    fi
}
parse_veri() {
    local mail="$1"
    while IFS=':' read -r key value; do
                #sleep 0.1
        if [ "$key" == "info" ]; then
                        echo "Bu key $value"
                        #echo "company:$value"
                # base64 kontrolü yap
                if is_base64 "$value"; then
                    #echo "Veri base64 formatında."
                    # Base64 ile decode et
                    decoded_veri=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' |base64 -d)
                    info_value=$(echo "$decoded_veri" | tr ';' '|')
                        echo "info value1: $info_value"
                                echo "mail:$mail"
                                /opt/zimbra/bin/zmprov ma $mail  company "$info_value"

                else
                    #echo "Veri base64 formatında degil"
                        info_value=$(echo $veri | awk -F': ' '{print $2}')
                        echo "info value2: $info_value"
                                echo "mail:$mail"
                                /opt/zimbra/bin/zmprov ma $mail  company "$info_value"

                        fi
                elif [ "$key" == "mobile" ]; then
                mobile_value=$(echo "$value"| sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                echo "mobile:$mobile_value"
                /opt/zimbra/bin/zmprov ma $mail  mobile "$mobile_value"
        
        elif [ "$key" == "homePhone" ] ; then
                homePhone_value=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                echo "homePhone:$homePhone_value"
                /opt/zimbra/bin/zmprov ma $mail  telephoneNumber "$homePhone_value"

        elif [ "$key" == "ipPhone" ]; then
                ipPhone_value=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                echo "ipPhone:$ipPhone_value"
                /opt/zimbra/bin/zmprov ma $mail facsimileTelephoneNumber "$ipPhone_value"

        elif [ "$key" == "description" ]; then
                description_value=$(echo "$value" | tr ';' '|' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                if is_base64 "$value"; then
                    #echo "Veri base64 formatında."
                    # Base64 ile decode et
                    decoded_veri=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' |base64 -d)
                    description_value=$(echo "$decoded_veri" | tr ';' '|')
                        echo "Description value1: $description_value"
                                echo "mail:$mail"
                                /opt/zimbra/bin/zmprov ma $mail  ou "$description_value"

                else
                    #echo "Veri base64 formatında degil"
                        info_value=$(echo $veri | awk -F': ' '{print $2}')
                        echo "Description value2: $info_value"
                                echo "mail:$mail"
                                /opt/zimbra/bin/zmprov ma $mail  ou "$description_value"

                        fi
                #echo "description:$description_value"
                #/opt/zimbra/bin/zmprov ma $mail  ou "$description_value"

        #streetAddress

        elif [ "$key" == "streetAddress" ]; then
                        echo "Bu adres: $value"
                        #echo "company:$value"
                # base64 kontrolü yap
                if is_base64 "$value"; then
                    #echo "Veri base64 formatında."
                    # Base64 ile decode et
                    decoded_veri=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' |base64 -d)
                    address_value=$(echo "$decoded_veri" | tr ';' '|')
                        echo "info value1: $address_value"
                                echo "mail:$mail"
                                /opt/zimbra/bin/zmprov ma $mail  streetAddress "$address_value"

                else
                    #echo "Veri base64 formatında degil"
                        address_value=$(echo $veri | awk -F': ' '{print $2}')
                        echo "info value2: $address_value"
                                echo "mail:$mail"
                                /opt/zimbra/bin/zmprov ma $mail streetAddress "$address_value"

                        fi
        #postOfficeBox
        elif [ "$key" == "postOfficeBox" ]; then
                OfficeBox_value=$(echo "$value" | tr ';' '|' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
                echo "OfficeBox:$OfficeBox_value"
                /opt/zimbra/bin/zmprov ma $mail  l "$OfficeBox_value"
        fi
    done
}


hesaplar=$(/opt/zimbra/bin/zmprov -l gaa domian.com)

echo "$hesaplar" | while read -r value; do
    echo "$value"
    
    readarray -t GetData <<<$(/opt/zimbra/common/bin/ldapsearch -LLL -o ldif-wrap=no -b dc=domian,dc=local -D zimbra@domian.local -w Password_here -H ldap://192.168.1.10 "(mail=$value)")

    for (( i=0; i<${#GetData[@]}; i++ )); do

        veri="${GetData[$i]//::/: }"
        echo "$veri" | parse_veri "$value"
    done   

done
