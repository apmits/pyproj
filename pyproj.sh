#!/usr/bin/env bash

proj=$1
# echo $1
if [ -z "$1" ]; then
  echo 'Usage:'
  echo 'pyproj <name>'
  exit 0
fi
cd "`pwd`" || exit

echo "# Creating directory $proj ..."
mkdir $proj
cd $proj || exit

echo '# Creating Python3 virtual environment in .venv/ ...'
virtualenv -p python3 .venv
#   depending on your setup, try this instead:   python3 -m venv .venv

echo "# Creating $proj.py ..."
#python2shebang='#!/usr/bin/env python'
python3shebang='#!/usr/bin/env python3'
encoding='# -*- coding: utf-8 -*-'
python_content="$python3shebang
$encoding

# import ...


def main():
    pass


if __name__ == '__main__':
    main()
"
if [ -e $proj'.py' ]; then
  echo "  file $proj.py already exists - nothing added."
else
  echo "$python_content" > $proj'.py'
fi
echo "  +x $proj.py ..."
chmod +x $proj'.py'

echo "# Creating requirements.txt ..."
reqs_txt="# pip install -r requirements.txt
#
#pprint
#requests
#redis # (redis-py) - The Python interface to the Redis key-value store.
#celery
#flask
#pickle # (only for Python2) - for Python3, pickle comes as standard library.
"
if [ -e 'requirements.txt' ]; then
  echo "  file requirements.txt already exists - nothing added."
else
  echo "$reqs_txt" > 'requirements.txt' # preserve newlines explanation:
fi

echo "# Creating .ftpconfig ..."
ftpconfig_content="// to sync all files in the project using Atom+remote-ftp plugin: select the local directory ($proj), right-click, sync local -> remote.
// if you delete a local file, you need to manually delete it remotely.
// after a sync, you need to select the remote ($proj) directory, right-click, refresh; to update the view.
// .ftpconfig is json formatted (single quotes not allowed). original sample from:   https://atom.io/packages/remote-ftp
{
    \"protocol\": \"sftp\",
    \"host\": \"ec2-XXX-XXX-XXX-XXX.eu-central-1.compute.amazonaws.com\", // string - Hostname or IP address of the server. Default: 'localhost'
    \"port\": 22, // integer - Port number of the server. Default: 22
    \"user\": \"ubuntu\", // string - Username for authentication. Default: (none)
    \"pass\": \"\", // string - Password for password-based user authentication. Default: (none)
    \"promptForPass\": false, // boolean - Set to true for enable password/passphrase dialog. This will prevent from using cleartext password/passphrase in this config. Default: false
    \"remote\": \"/home/ubuntu/$proj\", // try to use absolute paths starting with /    project dir will be created during the 1st sync, if it doesn't exist.
    \"agent\": \"\", // string - Path to ssh-agent's UNIX socket for ssh-agent-based user authentication. Windows users: set to 'pageant' for authenticating with Pageant or (actual) path to a cygwin 'UNIX socket.' Default: (none)
    \"privatekey\": \"~/.ssh/example.pem\", // string - Absolute path to the private key file (in OpenSSH format). Default: (none)
    \"passphrase\": \"\", // string - For an encrypted private key, this is the passphrase used to decrypt it. Default: (none)
    \"hosthash\": \"\", // string - 'md5' or 'sha1'. The host's key is hashed using this method and passed to the hostVerifier function. Default: (none)
    \"ignorehost\": true,
    \"connTimeout\": 10000, // integer - How long (in milliseconds) to wait for the SSH handshake to complete. Default: 10000
    \"keepalive\": 10000, // integer - How often (in milliseconds) to send SSH-level keepalive packets to the server (in a similar way as OpenSSH's ServerAliveInterval config option). Set to 0 to disable. Default: 10000
    \"watch\":[ // array - Paths to files, directories, or glob patterns that are watched and when edited outside of the atom editor are uploaded. Default : []
        \"./dist/stylesheets/main.css\", // reference from the root of the project.
        \"./dist/stylesheets/\",
        \"./dist/stylesheets/*.css\"
    ],
    \"watchTimeout\":500, // integer - The duration ( in milliseconds ) from when the file was last changed for the upload to begin.
    \"filePermissions\": \"\" // string - (eg 0744) Permissions for uploaded files. WARNING: if this option is set, previously set permissions on the remote are overwritten!
}
"
if [ -e '.ftpconfigN' ]; then
  echo "  file .ftpconfigN already exists - nothing added."
else
  echo "$ftpconfig_content" > '.ftpconfigN'
fi

echo "# Creating .ftpignoreN ..."
ftpignore_content=".ftpconfig*
.ftpignore*
.DS_Store
.venv
.idea
__pycache__
redis-stable
celerybeat-schedule
build
dist
*.spec
*.pyc
"
if [ -e '.ftpignoreN' ]; then
  echo "  file .ftpignore already exists - nothing added."
else
  echo "$ftpignore_content" > '.ftpignoreN'
fi

echo "# Creating .gitignore ..."
# should really use this:   https://github.com/github/gitignore/blob/master/Python.gitignore
# ...same as ftpignore_content for now ...
gitignore_content=".ftpconfig*
.ftpignore*
.DS_Store
.venv
.idea
__pycache__
redis-stable
celerybeat-schedule
build
dist
*.spec
*.pyc
"
if [ -e '.gitignore' ]; then
  echo "  file .gitignore already exists - nothing added."
else
  echo "$gitignore_content" > '.gitignore'
fi

echo '# Done! -------------------------------------'
echo
echo "  cd $proj && source .venv/bin/activate"
echo
echo '# to deactivate .venv:'
echo '  deactivate'
