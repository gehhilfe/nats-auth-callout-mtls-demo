#!/bin/bash
pushd /tmp
wget https://github.com/nats-io/natscli/releases/download/v0.1.1/nats-0.1.1-amd64.deb
sudo apt install -f ./nats-0.1.1-amd64.deb

wget https://github.com/nats-io/nats-server/releases/download/v2.10.5/nats-server-v2.10.5-amd64.deb
sudo apt install -f ./nats-server-v2.10.5-amd64.deb

wget https://github.com/nats-io/nsc/releases/download/v2.8.5/nsc-linux-amd64.zip
sudo unzip nsc-linux-amd64.zip -d /usr/local/bin
popd

sudo apt install -y openssl
pushd keys/

# Create server certificate
rm server.crt
rm server.key
openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout server.key -out server.crt -config req.conf -extensions 'v3_req'

# Create client ca
rm client-ca.crt
rm client-ca.key
openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout client-ca.key -out client-ca.crt -config ca.conf -extensions 'v3_req'

# Create auth certificate
rm auth.key
openssl genrsa -out "auth.key" 4096
rm auth.csr
openssl req -new -key "auth.key" -out "auth.csr" -sha256 -subj '/CN=Auth Client'
openssl x509 -req -days 750 -in "auth.csr" -sha256 -CA "client-ca.crt" -CAkey "client-ca.key" -CAcreateserial -out "auth.crt" -extfile "auth.conf" -extensions auth

# Create client A
rm client-a.key
openssl genrsa -out "client-a.key" 4096
rm client-a.csr
openssl req -new -key "client-a.key" -out "client-a.csr" -sha256 -subj '/CN=client-a Client'
openssl x509 -req -days 750 -in "client-a.csr" -sha256 -CA "client-ca.crt" -CAkey "client-ca.key" -CAcreateserial -out "client-a.crt" -extfile "client.conf" -extensions client

# Create client B
rm client-b.key
openssl genrsa -out "client-b.key" 4096
rm client-b.csr
openssl req -new -key "client-b.key" -out "client-b.csr" -sha256 -subj '/CN=client-b Client'
openssl x509 -req -days 750 -in "client-b.csr" -sha256 -CA "client-ca.crt" -CAkey "client-ca.key" -CAcreateserial -out "client-b.crt" -extfile "client.conf" -extensions client

popd