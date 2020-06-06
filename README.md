# SSH with Docker Guide Improved

The [guide](https://docs.docker.com/engine/examples/running_ssh_service/) was refactored.
Checkout the [Dockerfile](Dockerfile) for more info.

# Build Arguments

**Build Arguments Table**:

| Argument          | Default    |
| ----------------- | ---------- |
| SSH_USER          | greg       |
| SSH_USER_PASSWORD | 123        |
| SSH_USER_HOME     | /home/greg |
| SSH_ROOT_PASSWORD | 123        |

# Build

```shell script
docker build -f Dockerfile -t greg .
```

# Run

We should use **--init** so the signals'd be properly forwarded:
```shell script
docker run --init --name greg -it -d --rm -p 4242:22 greg

# The signals will be forwarded:
docker exec greg sh -c 'kill $(pgrep ssh)'
```

You can run it interactively also:
```shell script
docker run --init --name greg -it --rm -p 4242:22 greg
```

# Use

```shell script
# Between runs the key will vary; remove it
ssh-keygen -f "/home/${USER}/.ssh/known_hosts" -R "[localhost]:4242" || true

# The password is in the Build Arguments Table; you can login under the root too
ssh -p 4242 -o PreferredAuthentications=password greg@localhost
```

# Cleanup

```shell script
docker rm --force greg
```

# Authors and License

I've (max.preobrazhensky@gmail.com) made it for local fiddling with Ansible; use it as you wish.

The license is Apache 2.0.


# Backlog

- [ ] CI

- [ ] DockerHub publishing
