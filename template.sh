#!/usr/bin/env bash
# -------------------------------------------------------------------------
# Bash script template
# -------------------------------------------------------------------------
# Website:       https://virtubox.net
# GitHub:        https://github.com/VirtuBox/bash-script-template
# Copyright (c) 2019 VirtuBox <contact@virtubox.net>
# This script is licensed under M.I.T
# -------------------------------------------------------------------------
# Version 1.0.0 - 2019-08-09
# -------------------------------------------------------------------------

##################################
# Initial checkup
##################################

# Check if user is root
[ "$(id -u)" != "0" ] && {
    echo "Error: You must be root or use sudo to run this script"
    exit 1
}

# clean previous install log
echo "" > /var/log/bash-template.log

##################################
# Help function
##################################

_help() {
    echo "Bash script template with arguments parsing"
    echo "Usage: template [type] <options> [mode]"
    echo "  Options:"
    echo "       -h, --help ..... display this help"
    echo "       -v, --version ....... display script version"
    echo ""
    echo "Examples:"
    echo ""
    echo "Display the script help :"
    echo "    template -h"
    echo ""
    echo ""
    return 0
}

##################################
# Arguments parsing
##################################

# if there is no args, display help
if [ "$#" -eq 0 ]; then
    _help

else
    # argument parsing
    while [ "$#" -gt 0 ]; do
        case "$1" in
        # display help alternatives arguments
        -h | --help | help)
            _help
            exit 1
            ;;
        --argument1)
            variable1="y"
            ;;
        --argument2)
            variable2="n"
            ;;
        # with --args ok -> argument_args="ok"
        --args)
            argument_args="$2"
            shift
            ;;
        *) ;;
        esac
        shift
    done
fi

# set default variable if the variable is still empty
if [ -z "$argument_args" ]; then
    argument_args="nothing"
fi
##################################
# Check requirements
##################################

# update apt-cache quietly
apt-get update -qq

# checking if curl is installed and install it if needed non interactive way
[ -z "$(command -v curl)" ] && { apt-get --assume-yes install curl; } >> /dev/null 2>&1

##################################
# Variables
##################################

OS_DISTRO_FULL="$(lsb_release -ds)"
DISTRO_ID="$(lsb_release -si)"
VARIABLE3="1.4.6"
FILE_PATH="/var/www"
TIME_FORMAT='%d-%b-%Y-%H%M%S'
TIME=$(date +"$TIME_FORMAT")
FILE="$FILE_PATH/file.$TIME.gz"

# Colors for output
CSI='\033['
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CEND="${CSI}0m"

##################################
# Functions
##################################

_install_non_interactive() {
    # display current running task
    echo -ne '       Installing non-interactive               [..]\r'
    # check code returned by this section
    if {
        # non interactive install with apt-get
        # force missing conf creation "--force-confmisss"
        # force keeping previous configuration, never overwrite with new config file "--force-confold"
        DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confmiss" -o Dpkg::Options::="--force-confold" -y install \
            git build-essential
    } >> /var/log/bash-template.log 2>&1; then
        # if code returned is 0, tasks were successfull
        echo -ne "       Installing non-interactive                [${CGREEN}OK${CEND}]\\r"
        echo -ne '\n'
    else
        # if code returned is 1, there were errors
        echo -e "        Installing non-interactive              [${CRED}FAIL${CEND}]"
        echo -e '\n      Please look at /var/log/bash-template.log\n'
        exit 1
    fi
}

_do_something() {
    echo -ne '       Doing something              [..]\r'
    if
        {
            echo "hello"
            echo "$OS_DISTRO_FULL"
            echo "$DISTRO_ID"
            echo "$FILE"
            echo "$VARIABLE3"
            # do something here

        } >> /var/log/bash-template.log 2>&1
    then
        # if code returned is 0, tasks were successfull
        echo -ne "       Doing something              [${CGREEN}OK${CEND}]\\r"
        echo -ne '\n'
    else
        # if code returned is 1, there were errors
        echo -e "       Doing something              [${CRED}FAIL${CEND}]"
        echo -e '\n      Please look at /var/log/bash-template.log\n'
        exit 1
    fi
}

##################################
# Main
##################################

# 1. install non interactive
_install_non_interactive

# 2. do something is variable1 = 1
if [ "$variable1" = "1" ]; then
    _do_something
elif [ "$variable2" = "n" ]; then
    echo "do something else"
else
    echo "nothing to do but args are $argument_args"
fi
