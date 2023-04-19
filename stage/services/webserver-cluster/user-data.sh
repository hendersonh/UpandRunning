#!/bin/bash
cat <<EOF | sudo tee index.html
  <h1>Hello, World</h1>
  <p>DB address: ${db_address}</p>
  <p>DB port: ${db_port}</p>
  EOF
  nohup busybox httpd -f -p ${server_port} &