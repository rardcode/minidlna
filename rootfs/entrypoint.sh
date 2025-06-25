#!/bin/bash
set -x

# put here dirs that must be made persistent
list_dirs() {
cat <<EOF
#/dirs/tobe/make/persistent
EOF
}

function _main {
 # If the following variables have a value of zero, set the default
 [ -z $mdPort ] && mdPort="8200"
 [ -z "$mdFriendlyname" ] && mdFriendlyname="Alpine DLNA Server"
 [ -z $mdInotify ] && mdInotify="yes"
 [ -z $mdEnabletivo ] && mdEnabletivo="no"
 [ -z $mdStrictdlna ] && mdStrictdlna="no"
 [ -z $mdNotifyinterval ] && mdNotifyinterval="895"
 [ -z $mdMaxconnections ] && mdMaxconnections="50"

 # make /etc/minidlna.conf file
 echo "port=$mdPort" > /etc/minidlna.conf
 echo "friendly_name=$mdFriendlyname" >> /etc/minidlna.conf
 echo "inotify=$mdInotify" >> /etc/minidlna.conf
 echo "enable_tivo=$mdEnabletivo" >> /etc/minidlna.conf
 echo "strict_dlna=$mdStrictdlna" >> /etc/minidlna.conf
 echo "notify_interval=$mdNotifyinterval" >> /etc/minidlna.conf
 echo "max_connections=$mdMaxconnections" >> /etc/minidlna.conf

 # grep all media_* envs & make minidlna.conf media_dir entry
 env | grep '^media_' | while read -r value; do
  value=$(echo $value | cut -d= -f2)
  echo "media_dir=$value" >> /etc/minidlna.conf
 done

 [ -e /run/minidlna/minidlna.pid ] && rm /run/minidlna/minidlna.pid

 # define CMD to be launched
 CMD="/usr/sbin/minidlnad -S"
}

function _dirs {
DEST_PATH="/data"

# make list of dirs that have to be persistent
outListDirs=$(list_dirs | grep -v ^#)
if [ ! -z $outListDirs ]; then

 echo "--------------------------------------"
 echo " Moving persistent data in $DEST_PATH "
 echo "--------------------------------------"

 list_dirs | while read path_name DUMMY; do
  if [ ! -e ${DEST_PATH}${path_name} ]; then
   if [ -d $path_name ]; then
    rsync -Ra ${path_name}/ ${DEST_PATH}/
   else
    rsync -Ra ${path_name} ${DEST_PATH}/
   fi
  else
   echo "---------------------------------------------------------"
   echo " No NEED to move anything for $path_name in ${DEST_PATH} "
   echo "---------------------------------------------------------"
  fi
  rm -rf ${path_name}
  ln -s ${DEST_PATH}${path_name} ${path_name}
 done
fi
}

function custom_bashrc {
echo '
export LS_OPTIONS="--color=auto"
alias "ls=ls $LS_OPTIONS"
alias "ll=ls $LS_OPTIONS -la"
alias "l=ls $LS_OPTIONS -lA"
'
}

function _bashrc {
echo "-----------------------------------------"
echo " .bashrc file setup..."
echo "-----------------------------------------"
custom_bashrc | tee /root/.bashrc
echo 'export PS1="\[\e[35m\][\[\e[31m\]\u\[\e[36m\]@\[\e[32m\]\h\[\e[90m\] \w\[\e[35m\]]\[\e[0m\]# "' >> /root/.bashrc
for i in $(ls /home); do echo 'export PS1="\[\e[35m\][\[\e[33m\]\u\[\e[36m\]@\[\e[32m\]\h\[\e[90m\] \w\[\e[35m\]]\[\e[0m\]$ "' >> /home/${i}/.bashrc; done
}

_dirs
_main
_bashrc

#CMD="$@"
[ -z "$CMD" ] && export CMD="supervisord -c /etc/supervisor/supervisord.conf"

exec $CMD

exit $?
