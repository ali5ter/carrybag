cite about-alias
about-alias 'CarryBag general aliases'

## Reload the bash environment
alias sourcep="source $BASHRC"

## Tail the aggregation of log files
alias allogs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

## Tail the standard httpd error log
[ -e /var/log/httpd/error_log ] && \
        alias wwwerror="sudo tail -f /var/log/httpd/error_log"

## Edit the hosts file
alias hosts="sudo vim /etc/hosts"
