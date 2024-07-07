cat << EOF >> ~/.ssh/learnazure

Host ${hostname}
  HostName ${hostname}
  User ${user}
  IdentityFile ${identityfile}
EOF