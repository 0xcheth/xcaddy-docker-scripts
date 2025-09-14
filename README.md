# xcaddy docker scripts
*for other containerner noobs such as I: WORKS WITH PODMAN and or DOCKER
# Description
This set of scripts is for a multistage build that creates a alpine container with golang inside it, this runs xcaddy to build a caddy binary with any plugins you want inside the container at build time!
# Purpose
This is intended to simplify the caddy setup process IF you want caddy with multiple plugins to run containerized and not on host baremetal.
# Setup
  - Move all files into target directory
  - Specify all the plugins you want in the **DOCKERFILE**
  - configure caddyfile and specify path to caddyfile in the **COMPOSE.yaml**
  - rename the caddy.conf file to **.env !! IMPORTANT !!** make sure this is in the same root path as your compose file
  - Add any api keys, secrets and passwords to the .env file
  - Run the compose file with podman-compose or docker compose!
  - Your caddy container with plugins will autostart with the contianer :D
# Credit
Credit to the Caddyserver contributors and ![mholt](https://github.com/mholt) for building great server tools like xcaddy and caddy!
