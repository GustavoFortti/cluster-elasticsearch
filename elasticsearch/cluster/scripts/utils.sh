function loading_bar() {
    local duration="$1"
    local bar_length=50
    local sleep_interval=$(echo "$duration / $bar_length" | bc -l)


    echo -ne "["
    for ((i = 0; i < bar_length; i++)); do
        echo -ne "#"
        sleep $sleep_interval
    done
    echo -ne "]"

    echo -e "\nDone!"
}

message() {
    local current_time
    current_time=$(date "+%Y-%m-%d %H:%M:%S")
    local message="$1"

    echo "<SYSYEM> - [$current_time] - $message"
}