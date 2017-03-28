#! /bin/bash

#set -x
#set -o

gpg_cmd="/usr/bin/gpg2"
db_path="$HOME/.pass.gpg"
delimiter='/'
view_pass=0


declare -a passwords
username=''
password=''


function import_gpg_db {
  local i=0

  if [ -f "$db_path" ]; then
    for pass in $($gpg_cmd < "$db_path" 2>/dev/null); do
      passwords[$i]=$pass
      ((i++))
    done
  else
    echo "Can not find databse"
    echo "Creating empty database in $db_path"
    echo > "$db_path"
  fi

}

function export_gpg_db {
  echo test

}

function add_pass {
  local service="$1"

  passwords+=(${service}${delimiter}${username}${delimiter}${password})
  
}

function remove_pass {
  local service="$1"
  
  for pass_nr in {0..#passwords}; do
    if [[ $passwords[$pass_nr] =~ ^${service} ]]; then
     echo lol 
    fi
  done
}

function return_pass {
   local service="$1"
   local i=0

   for pass in "${passwords[@]}"; do
     if [[ $pass =~ ^${service}${delimiter}(.+)${delimiter}(.+)$ ]]; then
       if [[ $view_pass -eq 1 ]]; then
        echo "User: ${BASH_REMATCH[1]}"
        echo "Password: ${BASH_REMATCH[2]}"
      else
        echo "User: ${BASH_REMATCH[1]} Copied to CLIPBOARD(soon)"
      fi
     fi
   done
   exit -1
}

function _usage {
  cat <<EOF
Usage: $0 [options] service

      -v| --view                   view the password in cleartext
      -u| --user                   change or add username for service
      -p| --pass                   change or add password for service
      -a| --add                    add username and password
      -h| --help                   prints usage menu
EOF
}





##### MAIN #####
while [[ $# -gt 0 ]]; do
  arg="$1"

  case $arg in
    -v|--view)
      view_pass=1
      ;;
    -u|--user)
      username="$2"
      ;;
    -p|--pass)
      password="$2"
      ;;
    -h|--help)
      _usage
      exit 0
      ;;
    -a|--add)
      echo "$username"
      echo "$password"
      ;;
    *)
      import_gpg_db
      return_pass "${!#}"
  esac
  shift
done

#import_gpg_db
#return_pass $1


