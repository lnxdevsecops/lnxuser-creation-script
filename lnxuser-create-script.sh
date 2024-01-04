#!/bin/bash

# color code
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
    rand_pass=$(openssl rand -base64 12)
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

# read -p "Please enter users names by giving white space. Please don't use comma '(,)': " username
# echo " "
# for users in $username; do
#     id $users 2>/dev/null 1>/dev/null
#     if [ $? != 0 ]; then
#         echo "$users is not exist...Proceeding to create a $user user.....!"
#         useradd -m $users
#         user_details=$(grep -w "$users" /etc/passwd)

#         #Generating random password
#         rand_pass=$(openssl rand -base64 12)
#         # setting up the password
#         echo "Configuring random password for user $users......!"
#         # echo -e "$rand_pass\n$rand_pass" | passwd $uname 1>/dev/nuall
#         echo "$rand_pass" | passwd --stdin $users 1>/dev/null

#     else
#         echo "$users user is exists......!"
#     fi
# done

#             # exporting the user and password into the file
#             echo -e "UserName: $uname\nPassword: $rand_pass" >>$cred_file
#             echo " "

# #
# # if [ $? != 0 ]; then
# #     read -p "$uname does not exist...Do you want to create user type '"yes/no"': " action
# #     if [ "$action" == "yes" ]; then
# #         echo -e "Proceeding to create a $uname user.........\nPlease get details about $uname:"
# #         useradd -m $uname
# #         user_details=$(grep -w "$uname" /etc/passwd)
# #         echo " "
# #         echo "$user_details"
# #     else
# #         echo "Discarding user creation process....."
# #     fi
# #     # set password for user
# #     echo " "
# #     read -p "Do you want to set passwrod for user $uname 'yes/no': " password_action
# #     if [ "$password_action" == "yes" ]; then
# #         cred_file=/root/.credentials
# #         # creating credential file if doesn't exists
# #         if ! [ -e "$cred_file" ]; then
# #             touch $cred_file
# #             chmod 600 $cred_file
# #         else
# #             #Generating random password
# #             rand_pass=$(openssl rand -base64 12)
# #             # setting up the password
# #             echo "Configuring random password for user $uname......!\nYou will find password in $cred_file file"
# #             # echo -e "$rand_pass\n$rand_pass" | passwd $uname 1>/dev/nuall
# #             echo "$rand_pass" | passwd --stdin $uname 1>/dev/null
# #             # exporting the user and password into the file
# #             echo -e "UserName: $uname\nPassword: $rand_pass" >>$cred_file
# #             echo " "
# #         fi
# #     else
# #         echo "Discarding password configuration..........!"
# #     fi
# # else
# #     echo "$uname user is exists....!"
# # fi
