# status
simple script to act as a status page

# how to run
the script uses the environment values ping_hosts and http_hosts to select the targets, if youre running them from the cli, you most likely need to export them before like
```bash
export ping_hosts="localhost localhost" && export http_hosts="https://duck.com https://google.com" && ./status.sh
```
- do not quote individual hosts
- https needs to specified most of the time to avoid 308s

for running the script in docker, see the included compose file
