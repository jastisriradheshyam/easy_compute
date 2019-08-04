#!/bin/bash

# constants
token=<token>
chat_id=<chat_id>
common_url="https://api.telegram.org/bot$token"

# get the arguments
args=("${@}")

# Iterating the options
for i in "${!args[@]}"
do
    # Check for doc option
    if [ "${args[$i]}" = "-d" -o "${args[$i]}" = "--doc" ];then
        doc_opt="2"
        doc_index=$(($i+1))
        doc_path=${args[$doc_index]}
    fi;
    # Check for text message option
    if [ "${args[$i]}" = "-t" -o "${args[$i]}" = "--text" ];then
        text_opt="1"
        text_index=$(($i+1))
        text_message=${args[$text_index]}
    fi;
done

# send request to telegram (text message)
if [ "$text_opt" = "1" ]; then
    message_url="$common_url/sendMessage"
    curl -s -X POST $message_url -d chat_id=$chat_id -d text="$text_message"
fi

# send request to telegram (file)
if [ "$doc_opt" = "2" ]; then
    doc_url="$common_url/sendDocument"
    echo "$doc_url $doc_path"
    curl -s -X POST $doc_url -F chat_id=$chat_id -F document=@"./telegram_send.sh"
fi

# ----- EOF -----