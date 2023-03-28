export PATH=~/.toolbox/bin:/Users/cdeore/Library/Python/3.8/bin:/usr/local/bin/:$PATH

export BRAZIL_PLATFORM_OVERRIDE=AL2_x86_64
export DEVD=dev-dsk-cdeore-2b-68eaa45d.us-west-2.amazon.com
export DEVD2=dev-dsk-cdeore-2b-e87ebde5.us-west-2.amazon.com
export DEVC2012=172.16.236.59
export DEVD2012=dev-dsk-cdeore-2b-c4b4c395.us-west-2.amazon.com
export BASTION_IAD=ec2-44-203-12-215.compute-1.amazonaws.com
export BASTION_PDX=ec2-35-93-128-23.us-west-2.compute.amazonaws.com
#cdeoredevvm.aka.corp.amazon.com
#export DEVD2=cdeoredevvm2012.aka.corp.amazon.com
#export DEVD2=dev-dsk-cdeore-2b-47a11d75.us-west-2.amazon.com
#export DEVD2=CDeore-Dev-VM.aka.corp.amazon.com

#alias gammaA='ssh -i "~/KeyPairs/cdeore-647908610912-us-west-2-keypair.pem" ec2-user@34.216.175.168'
#alias gammaB='ssh -i "~/KeyPairs/cdeore-647908610912-us-west-2-keypair.pem" ec2-user@35.85.35.170'

alias tlsserver='ssh -o ProxyCommand="ssh -i ~/KeyPairs/east-west-keypair.pem -W %h:%p ec2-user@ec2-44-203-12-215.compute-1.amazonaws.com" -i ~/KeyPairs/east-west-keypair.pem ubuntu@ip-10-0-1-10.ec2.internal'
alias tlsserver2='ssh -o ProxyCommand="ssh -i ~/KeyPairs/east-west-keypair.pem -W %h:%p ec2-user@ec2-44-203-12-215.compute-1.amazonaws.com" -i ~/KeyPairs/east-west-keypair.pem ubuntu@ip-10-0-1-116.ec2.internal'
alias tlsclient='ssh -o ProxyCommand="ssh -i ~/KeyPairs/east-west-keypair.pem -W %h:%p ec2-user@ec2-44-203-12-215.compute-1.amazonaws.com" -i ~/KeyPairs/east-west-keypair.pem ubuntu@ip-10-0-2-20.ec2.internal'
alias tlsclient2='ssh -o ProxyCommand="ssh -i ~/KeyPairs/east-west-keypair.pem -W %h:%p ec2-user@ec2-44-203-12-215.compute-1.amazonaws.com" -i ~/KeyPairs/east-west-keypair.pem ubuntu@ip-10-0-2-221.ec2.internal'
alias betauA='ssh -i "~/KeyPairs/cdeore-647908610912-us-east-1-keypair.pem" ubuntu@54.174.104.144'
alias betauB1='ssh -i "~/KeyPairs/cdeore-647908610912-us-east-1-keypair.pem" ubuntu@3.80.173.198'
alias betauB2='ssh -i "~/KeyPairs/cdeore-647908610912-us-east-1-keypair.pem" ubuntu@3.231.211.184'
alias betauA2='ssh -i "~/KeyPairs/cdeore-647908610912-us-east-1-keypair.pem" ubuntu@3.236.177.106'


my-firewall-policy() {
     timedcmd aws network-firewall --region us-east-1 --endpoint-url https://iad.beta.customer.vanta.aws.a2z.com --no-verify-ssl describe-firewall-policy --firewall-policy-arn arn:aws:network-firewall:us-east-1:647908610912:firewall-policy/cdeore-iad-test 
}

my-firewall-policy-update-token() {
     my-firewall-policy 2>&1 >/dev/null | grep UpdateToken | awk 'BEGIN { FS = ",[ \t\":]*|[ \t\":]+" } {print $3}'
}


tls_on () {
     timedcmd aws  network-firewall update-firewall-policy --region us-east-1 \
          --firewall-policy-name cdeore-iad-test --firewall-policy-arn \
          arn:aws:network-firewall:us-east-1:647908610912:firewall-policy/cdeore-iad-test \
          --update-token `my-firewall-policy-update-token` \
          --endpoint-url https://iad.beta.customer.vanta.aws.a2z.com --no-verify-ssl  \
#          --firewall-policy '{"StatelessDefaultActions": ["aws:forward_to_sfe"], "StatelessFragmentDefaultActions": ["aws:forward_to_sfe"], "TLSInspectionConfigurationArn": "arn:aws:network-firewall:us-east-1:647908610912:tls-configuration/TLSTestConfigWithCombinedWayfarerserverAndCdeoreCertAnd10SubnetTraffic"}'
          --firewall-policy '{"StatelessDefaultActions": ["aws:forward_to_sfe"], "StatelessFragmentDefaultActions": ["aws:forward_to_sfe"], "TLSInspectionConfigurationArn": "arn:aws:network-firewall:us-east-1:647908610912:tls-configuration/TLSTestConfigWithCombinedWayfarerserverAndCdeoreCertAndBidirStrictTraffic"}'
     my-firewall-policy
}

tls_off () {
     timedcmd aws  network-firewall update-firewall-policy --region us-east-1 \
          --firewall-policy-name cdeore-iad-test --firewall-policy-arn \
          arn:aws:network-firewall:us-east-1:647908610912:firewall-policy/cdeore-iad-test \
          --update-token `my-firewall-policy-update-token` \
          --endpoint-url https://iad.beta.customer.vanta.aws.a2z.com --no-verify-ssl  \
          --firewall-policy '{"StatelessDefaultActions": ["aws:forward_to_sfe"], "StatelessFragmentDefaultActions": ["aws:forward_to_sfe"], "TLSInspectionConfigurationArn": "arn:aws:network-firewall:us-east-1:647908610912:tls-configuration/TLSTestConfigWithCombinedWayfarerserverAndCdeoreCertAndReject10SubnetTraffic"}'
     my-firewall-policy
}

tls_on_pass_anyany () {
     timedcmd aws  network-firewall update-firewall-policy --region us-east-1 \
          --firewall-policy-name cdeore-iad-test --firewall-policy-arn \
          arn:aws:network-firewall:us-east-1:647908610912:firewall-policy/cdeore-iad-test \
          --update-token `my-firewall-policy-update-token` \
          --endpoint-url https://iad.beta.customer.vanta.aws.a2z.com --no-verify-ssl  \
          --firewall-policy '{"StatelessDefaultActions": ["aws:forward_to_sfe"], "StatelessFragmentDefaultActions": ["aws:forward_to_sfe"], "TLSInspectionConfigurationArn": "arn:aws:network-firewall:us-east-1:647908610912:tls-configuration/TLSDeleteDemo-viksau-cert-key-unidir", "StatefulRuleGroupReferences": [{"ResourceArn": "arn:aws:network-firewall:us-east-1:647908610912:stateful-rulegroup/cdeore-beta-iad-pass-all"}]}'
     my-firewall-policy
}

tls_off_pass_anyany () {
     timedcmd aws  network-firewall update-firewall-policy --region us-east-1 \
          --firewall-policy-name cdeore-iad-test --firewall-policy-arn \
          arn:aws:network-firewall:us-east-1:647908610912:firewall-policy/cdeore-iad-test \
          --update-token `my-firewall-policy-update-token` \
          --endpoint-url https://iad.beta.customer.vanta.aws.a2z.com --no-verify-ssl  \
          --firewall-policy '{"StatelessDefaultActions": ["aws:forward_to_sfe"], "StatelessFragmentDefaultActions": ["aws:forward_to_sfe"], "StatefulRuleGroupReferences": [{"ResourceArn": "arn:aws:network-firewall:us-east-1:647908610912:stateful-rulegroup/cdeore-beta-iad-pass-all"}]}'
     my-firewall-policy
}

missing_metrics () {
    if [[ $# != 2 ]]; then
        echo "Usage: missing_metrics <cell_name> <az name>"
        return
    fi

    pushd /Users/cdeore/workplace/VantaOpsTools_justin/src/VantaOpsTools; 
    timedcmd brazil-runtime-exec fetch_missing_metrics_locations.py  --mechanic-command-type patch --auto-execute --cell-name $1 --az $2
    popd    
}

high_mem () {
    if [[ $# != 1 ]]; then
        echo "Usage: high_mem <cell_name>"
        return 
    fi

    pushd /Users/cdeore/workplace/VantaOpsTools_justin/src/VantaOpsTools; 
    timedcmd brazil-runtime-exec fetch_high_mem_util_locations.py --mem-threshold-percent 90.0 --auto-patch --cell-name $1
    popd    
}

proactive_mem_fix () {
    echo 'Authenticate before running the tool'
    #kinit && mwinit -o --aea -s
    in
    #echo y | mechanic configure execution trust-ssh-tools host
    #echo y | mechanic configure execution trust-aws-tools host aws

    pushd /Users/cdeore/workplace/VantaOpsTools_justin/src/VantaOpsTools
    for i in 10 9 8 7 6 5 4 3 2 1
    do
        echo "Running fetch_high_mem_util_locations.py on all cells for $i times"
        timedcmd brazil-runtime-exec fetch_high_mem_util_locations.py --mechanic-command-type patch --all-cells --mem-threshold-percent 90.0 --auto-execute
        echo ""
        echo "Sleeping for $((60*60)) seconds"
        sleep $((60*60))
    done
    popd    
}

ticket_summery() {
    today=($(date +%w))
    #today=$((($(date +%w))+$1)) # This is for testing using - for i in {0..6}; do; ./dt $i; echo -----------------------; done
    #echo today = $today - `date -v "+$(( (7-$(date '+%w')+$today)%7 ))d" '+%A'` - `date "+%Y-%m-%d"`

    if [[ $today -eq 1 ]]
    then
        end=$((($today - 1 + 7)%7));
        start=$((7-end))
    else
        start=$((($today - 1 + 7)%7));
        end=$((7-start))
    fi


    startdate=`date -v -${start}d "+%Y-%m-%d"`
    enddate=`date -v +${end}d "+%Y-%m-%d"`

    #echo $start - $today - $end
    #echo $startdate - $enddate

    pushd /Users/cdeore/workplace/VantaOpsTools/src/VantaOpsTools
    echo "brazil-runtime-exec generate_ticket_summary --start $startdate --end $enddate --resolver-group-key DP"
    timedcmd brazil-runtime-exec generate_ticket_summary --start $startdate --end $enddate --resolver-group-key DP
    popd
}

alias patching_summary='timedcmd brazil-runtime-exec generate_patching_summary --team DP'

get-ypass() {
   echo -e "Touch the yubikey: "
   vared -p '> ' -c ypass
   echo $ypass
}

# Login to midway and kerberos. Must supply amazon_midway and amazon_kerberos passwords MACOS-ONLY
localinit() {
   local USER=`whoami`
   local apass=`security find-generic-password -w -s 'amazon_kerberos' -a $USER`
   local mpass=`security find-generic-password -w -s 'amazon_midway' -a $USER`
   echo "Authenticating you on MacOS"   
   echo $apass | kinit --password-file=STDIN
   expect -f ~/.scripts/mwlocalinit.exp $mpass 
   eval ssh-add
}

devdinit() {
   local USER=`whoami`
   local ypass
   local apass=`security find-generic-password -w -s 'amazon_macbook' -a $USER`
   local mpass=`security find-generic-password -w -s 'amazon_midway' -a $USER`
   echo "Authenticating you on the Cloud Desktop"
   echo -e "Touch the yubikey: "
   vared -p '> ' -c ypass
   expect -f ~/.scripts/devdinit.exp $1 $apass $mpass $ypass
}

localanddevdinit() {
    read -qs -t 3 '?Do you want to do mwinit on your MacBook & Cloud Desktop (y/[n])? ' yn
    echo $yn
    if [ "$yn" = "y" ]
    then 
        localinit
	devdinit $DEVD
    else
       echo No credentials entered.
       echo
    fi
}

localanddevdinit2() {
    read -qs -t 3 '?Do you want to do mwinit on your MacBook & AL2012 Cloud Desktop (y/[n])? ' yn
    echo $yn
    if [ "$yn" = "y" ]
    then
        localinit
        devdinit $DEVD2012
    else
       echo No credentials entered.
       echo
    fi  
}

_vpn-connected() {
   /opt/cisco/anyconnect/bin/vpn status | grep "state: Connected"
   grep -q "state: Connected" <<< "$(/opt/cisco/anyconnect/bin/vpn status)"
}

vpnit() {
   _vpn-connected && return 0;
   local CONNECTED=
   local USER=`whoami`
   local ypass
   local apass=`security find-generic-password -w -s 'amazon_macbook' -a $USER`
   local mpass=`security find-generic-password -w -s 'amazon_midway' -a $USER`
   echo -e "Touch the yubikey: "
   vared -p '> ' -c ypass
   expect -f ~/.scripts/vpnit.exp $USER $apass $mpass $ypass
}

vpnnit() {
   vpnit && localinit
}

gda() {
   git diff --name-only "$@" | while read filename; do
      (&>/dev/null git difftool "$@" --no-prompt "$filename" &)
   done
}

function dp_connect () {
    length=$(($# - 1))
    readonly dp_instance_ip=${1:?"The DP instance IP must be specified. Usage: dp_connect <dp instance ip> <bastion dns>"}
    readonly bastion_dns=${2:?$"The Bastion DNS must be specified. Usage: dp_connect <dp instance ip> <bastion dns>"}

    echo ssh -o "ProxyCommand ssh -W $dp_instance_ip:22 $bastion_dns" $dp_instance_ip
    ssh -o "ProxyCommand ssh -W $dp_instance_ip:22 $bastion_dns" $dp_instance_ip
}

newline () { for (( i=0; i<=$1; i++ )); do echo; done; }

alias i=localinit
alias in=vpnnit
#alias i='mwinit -s -o && clear'
#alias in='kinit && mwinit -s --aea -o && clear'
alias ivp='/opt/cisco/anyconnect/bin/vpn status'
alias iv=' printdatetime "        Current Time"; ssh-keygen -L -f ~/.ssh/id_rsa-cert.pub | grep Valid'
alias minfo='cat /etc/hardware.amazon.stanza'

alias python=python3
alias p3='python3'
alias cat='bat'

alias aws='/usr/local/bin/aws'
alias csd='ssh $DEVD'
alias csdg='localanddevdinit && killall dvcviewer && python3 ./dcv-cdd.py --fullscreen connect $DEVD'
alias csdin='localanddevdinit && csd'
alias scpcd='tmpfn() { echo scp "$1" cdeore@$DEVD:"$2"; scp "$1" cdeore@$DEVD:"$2";  unset -f tmpfn; }; tmpfn'

alias bkpdevd='timedcmd rsync -aHS --human-readable --progress -e ssh --exclude="cdeore" --exclude="workplace" --exclude=".local/share/Trash" cdeore@$DEVD:/home/cdeore/ ~/DEVD-Backup/cdeore'

alias csd2='ssh $DEVD2012'
alias csdg2='localanddevdinit2 && killall dvcviewer && python3 ./dcv-cdd.py --fullscreen connect $DEVD2012'
alias csdin2='localanddevdinit2 && csd2'
alias scpcd2='tmpfn() { echo scp "$1" cdeore@$DEVD2012:"$2"; scp "$1" cdeore@$DEVD2012:"$2";  unset -f tmpfn; }; tmpfn'
alias scprcd2='tmpfn() { echo scp cdeore@$DEVD2012:"$2" "$1"; scp cdeore@$DEVD2012:"$2" "$1";  unset -f tmpfn; }; tmpfn'
alias bkpdevd2='timedcmd rsync -aHS --human-readable --progress -e ssh --exclude="cdeore" --exclude="workplace" --exclude=".local/share/Trash" cdeore@$DEVD2012:/home/cdeore/ ~/DEVD2-Backup/cdeore'

alias gdiff='git difftool -y'
alias nds='ninja-dev-sync'
alias ndss='nds -setup'
alias gdiff='git difftool -y'
alias gd='gda'
alias ga='git add'
alias gm='git commit -m'
alias gam='git commit --amend --no-edit'
alias gitamend='git commit --amend --no-edit'
alias gl='git log -n'
alias gs='git status'
alias gb='git branch'
alias gcr='git switch -c'
alias gsw='git switch'
alias gp='git pull --rebase'
alias gst='git stash'
alias gstl='git stash list'
alias e=emacs
alias sl=subl

alias b='brazil'
alias bws='brazil ws'
alias bwscr='bws create -n'
alias bwscreate='bws create -n'
alias bwsuse='bws use -p'
alias bwsls='bws show'
alias bwsdel='bws delete --root'
alias bwsrm='bws delete --root'
alias bwsrmp='bws remove -p'
alias bwspl='bws use -platform AL2_x86_64'
alias bwscl='bws clean'
alias bcl='bwscl'
alias bwssync='bws sync --md; bws sync'
alias bb='timedcmd brazil-build' # -j $CORES'
alias br='timedcmd brazil-recursive-cmd brazil-build release' # -j $CORES'
#alias br='printdatetime "Build start time" > /tmp/tmpdtm; brazil-build release -j $CORES; cat /tmp/tmpdtm; printdatetime "Build end time  "; rm /tmp/tmpdtm;'

alias bba='timedcmd brazil-build apollo-pkg' # -j $CORES'
alias bre='timedcmd brazil-runtime-exec' # -j $CORES'
#alias brc='timedcmd brazil-recursive-cmd' # -j $CORES'
#alias bbr='timedcmd brazil-recursive-cmd brazil-build'
alias bball='br --allPackages'
alias bbb='timedcmd brazil-recursive-cmd --allPackages brazil-build'
alias bbra='bbr apollo-pkg'

alias bwsattach='timedcmd brazil workspace env attach --alias'
alias bwsattachlbw='timedcmd brazil workspace env attach --alias LookoutBlackWatch; timedcmd brazil ws env update'

alias bwtest=tools/standalone/run_test-runtime_unit_tests.sh
export bwtest=tools/standalone/run_test-runtime_unit_tests.sh

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias sam="brazil-build-tool-exec sam"

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

# Enable autocompletion for mechanic.
[ -f "$HOME/.local/share/mechanic/complete.zsh" ] && source "$HOME/.local/share/mechanic/complete.zsh"


printdatetime()
{
  local DateTime=`date`
  echo $1: ${DateTime}
}

srch() {
    length=$(($# - 1))

    if [[ $length>0 ]]; then
        names=${@:1:$length}  #all args but last
        path_to_search_in="${@: -1}" #last arguement
    else
        names=$@ #single arg
        path_to_search_in="." #current dir
    fi

    timedcmd eval find $path_to_search_in -name $names -exec ls -l {} +
}

st() {
    echo "Usage: st <text to search> [optional list of extension for the files to search the text in]"
    echo "       Searches text from files recursively in the current directory onwards. Optionaly provide file extension to restrict search only in files with that extension"
    echo "       For searching multiple words, inclose the words in quotes and separate them by \\\\\\\\\| "
    echo "       Example: st 'bps\\\\\\\\\|pps' c cpp txt json"
    echo

    length=$(($# - 1))

    if [[ $length>0 ]]; then
        text_to_search=$1  #first arg
        files_to_search_in=""
        #files_to_search_in="--include \\*.${@:2}" #all but first arguements
        for ext in "${@:2}"
        do
            files_to_search_in="$files_to_search_in --include \*.$ext"
        done #all but first arguements

        #text_to_search=${@:1:$length}  #all args but last
        #files_to_search_in="--include \\*.${@: -1}" #last arguement
    else
        text_to_search=$@ #single arg
        files_to_search_in="*" #all files
    fi

    eval grep -rn $text_to_search $files_to_search_in
    echo
    echo Finished running \"grep -rn \'${text_to_search//\\\\/\\}\' $files_to_search_in\"
}


timedcmd() {
    local Epoch=`date`;

    $@; #Run the command 

    echo "";
    echo "Finished running  : '$@'";
    echo "Command start time: ${Epoch}";
    echo "Command end time  : `date`";
}


function kj () {
    local kill_list="$(jobs)"

    if [ -n "$kill_list" ]; then
        # this runs the shell builtin kill, not unix kill, otherwise jobspecs cannot be killed
        # the `$@` list must not be quoted to allow one to pass any number parameters into the kill
        # the kill list must not be quoted to allow the shell builtin kill to recognise them as jobspec parameters
        # This is for linux: kill $@ $(sed --regexp-extended --quiet 's/\[([[:digit:]]+)\].*/%\1/gp' <<< "$kill_list" | tr '\n' ' ')
        kill $@ $(sed -r 's/\[([[:digit:]]+)\].*/%\1/gp' <<< "$kill_list" | tr '\n' ' ')
    else
        echo "No jobs to kill"
        return 0
    fi
}

alias ezsh='vi ~/.zshrc && source ~/.zshrc'
alias l='ls -AlrtFhG --color=auto'
alias x='exit'
alias c='clear'
alias p='pwd'
alias f='tree --prune -ahfD -P'
alias ping='ping -c 3'
alias pse='ps -axjf | grep '
alias kl='sudo kill -9'
alias srm='sudo rm -rf '
alias t='tail -f'
alias pause='echo "Press any key to continue..."; read -k1 -s'
alias cd..='cd ..'
alias l..='l ..'

