#!/bin/bash
YELLOW='\033[1;33m'
RED='\033[0;91m'
RESET='\033[0m' # Reset to default color

# ask input from user
read -p "Please provide user's name by separating white space. Please don't use comma '(,)': " username
echo " "

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
    useradd -m $new_user

    #Generating random password
    rand_pass=$(openssl rand -base64 14)
    # setting up the password
    # echo -e "$rand_pass\n$rand_pass" | passwd $uname 1>/dev/nuall
    echo "$rand_pass" | passwd --stdin $new_user 1>/dev/null

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
