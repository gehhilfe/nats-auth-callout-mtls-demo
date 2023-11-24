# Authentication Callout Demo with mTLS

## Requirements
- vscode
  - Extensions:
    - ms-vscode-remote.vscode-remote-extensionpack
- docker

This project use vscode dev containers. Make sure you have docker installed, 
running and when opening select open in container.

You can also always switch to the dev container in the bottom left.
The nats auth callout service code is based on https://github.com/ConnectEverything/nats-by-example/tree/main/examples/auth/callout


# Running the demo

1. Open in vscode with dev container.
2. Run `nats-server --config server/config.conf` on a terminal
3. Run auth callout service in vscode with F5 or launch target `Launch ACS`
4. Try connecting with client-cert-a
  1. Run `nats --tlscert keys/client-a.crt --tlskey keys/client-a.key --tlsca keys/server.crt account info`
5. Inspect debug console output
  1. You should find the incoming auth request encoded as jwt, decode on jwt.io and explorer information provided
  2. You should also find the response jwt, also decode and learn

# Dev Container

The dev container uses mcr.microsoft.com/devcontainers/go:1-1.21-bullseye as base image.
Following tools are installed:
 - nats-server v2.10.5
 - nats cli v0.1.1
 - nsc v2.8.5
 - openssl

During startup multiple certificates are created:

/keys/server Self signed server certificate for DNS localhost and IP 127.0.0.1
/keys/client-ca Self signed ca certificate
/keys/auth Client certificate issued by client ca with "CN=Auth Client", used by auth callout service
/keys/client-a Client certificate issued by client ca with "CN=client-a Client"
/keys/client-b Client certificate issued by client ca with "CN=client-b Client"

# Nats Server Configuration

server/config.conf

## Accounts

- SYS "System Account"
- APP "Application Account, without any login details"
- AUTH "Auth Account, environment for auth calllout service"
  - User: "CN=Auth Client"

## TLS

Uses keys/server as server certificate and client-ca to verify client certificates.
verify_and_map enables client certificate verification and mapping of client 
distinguished names to usernames. This allows the auth service to connect with his 
client certificate.

## Auth Callouts

**DONT USE THESE KEYS IN PRODUCTION!**

XKey is a (X) ed25519 key pair used to encrypt auth request and responses between 
nats-sever and auth callout service. Here only the public part is configured.

Seed:   (SX)AAXMRAEP6JWWHNB6IKFL554IE6LZVT6EY5MBRICPILTLOPHAG73I3YX4
Public: (X)AB3NANV3M6N7AHSQP2U5FRWKKUT7EG2ZXXABV4XVXYQRJGM4S2CZGHT

Issuer is account (A) ed25519 key pair but this time used to sign auth responses 
and not for encryption.

Seed: (SA)ANDLKMXL6CUS3CP52WIXBEDN6YJ545GDKC65U5JZPPV6WH6ESWUA6YAI
Pub: (A)BJHLOVMPA4CI6R5KLNGOB4GSLNIY7IOUPAJC4YFNDLQVIOBYQGUWVLA