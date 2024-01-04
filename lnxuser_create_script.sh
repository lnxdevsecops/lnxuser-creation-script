#!/bin/bash
YELLOW='\033[1;33m'
RED='\033[0;91m'
RESET='\033[0m' # Reset to default color

# ask input from user
read -p "Please provide user's name by separating white space. Please don't use comma '(,)': " username
echo " "

if [ -n "$username" ]; then

    for user in $username; do
        id $user 2>/dev/null 1>/dev/null
        if [ $? != 0 ]; then
            new_user_data+=$user
            new_user_data+=" "
        else
            exit_user_data+="$user"
            exit_user_data+=" "
        fi
    done

    # Creating new users
    echo -e "Creating  New Users.........! \n"

    for new_user in ${new_user_data[@]}; do

        #Generating random string
        rand_pass=$(openssl rand -base64 14)

        # ubuntu_os=$(grep -w Ubuntu /etc/os-release  | cut -d '=' -f2 | tr -d '"' | awk 'NR==2 {print $1}')

        #   if [ $ubuntu_os -eq "Ubuntu" ]; then
        ubuntu_os=$(grep -w Ubuntu /etc/os-release  | cut -d '=' -f2 | tr -d '"' | awk 'NR==2 {print $1}')

            if [ "$ubuntu_os" == "Ubuntu" ]; then
              adduser --disabled-password --gecos "" "$new_user" 1>/dev/null
              echo "$new_user:$rand_pass" | chpasswd 1>/dev/null
          else
              useradd -m $new_user
              echo "$rand_pass" | passwd --stdin $new_user 1>/dev/null
          fi

          if [ -n $rand_pass ]; then
              password_set="Yes"
          else
              password_set="No"
          fi

        # Shows user details
        echo -e "UserName: $new_user \nPassword Status: $password_set \n"

        # stores user and password details in /root/.credentials files
        echo -e "UserName: $new_user \nPassword: $rand_pass" >>/root/.credentials
        sleep 3
    done

    if [ -n "$exit_user_data" ]; then
        echo " "
        echo -e "${YELLOW}Unable to create users '"$exit_user_data"' as they are already exist.${RESET} \n"
    fi

    sleep 1
    echo -e "${RED}Please get user's credentials from /root/.credentials file.${RESET} \n"

else
    echo "You haven't provide any user name"
fi
