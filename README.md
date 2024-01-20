# firefox-overlay

Redirect all Firefox writes to a `tmpfs` backed [`overlay`](https://docs.kernel.org/filesystems/overlayfs.html).

This works by mounting an overlay over `~/.mozilla/firefox` and storing the upper portion of the overlay on a `tmpfs` mountpoint.

![Usage](usage.png)

## Installation

```sh
git clone https://gitlab.com/camj/firefox-overlay
cd firefox-overlay
make
make install
```

## Configuration

### Backup

Before starting, optionally backup `~/.mozilla/firefox`:

```sh
rsync -aAX ~/.mozilla/firefox/ ~/.mozilla/firefox_backup/
```

### Overlay

`firefox-overlay-helper` requires root permissions to mount/unmount the overlay.

#### sudo

Users of `sudo` need to add the following to `/etc/sudoers`:

```
<user> ALL=(ALL:ALL) NOPASSWD: /usr/local/bin/firefox-overlay-helper
```

#### doas

Users of `doas` need to add the following to `/etc/doas.conf`:

```
permit nopass <user> cmd /usr/local/bin/firefox-overlay-helper
```

#### Notes

* This is not required if `sudo`/`doas` is already configured in no password mode.

* If you installed `firefox-overlay` from your package manager, replace `/usr/local/bin` with `/usr/bin`.

<!-- ## Usage

```
USAGE:
    firefox-overlay [SUBCOMMAND]

SUBCOMMANDS:
    m, mount      Mount overlay
    u, unmount    Unmount overlay
    f, flush      Flush overlay to disk
    c, check      Check overlay status
``` -->

## Daemon

`firefox-overlay` needs to be configured as a daemon in order to mount the overlay automatically. This also allows the overlay to be flushed when the daemon is terminated.

### runit

Void Linux users can create a user based `runit` service:

```sh
mkdir -p ~/.sv
cp -rf init/runit/firefox-overlay ~/.sv/
```

Once done, add the following to your init script:

```
runsvdir /home/<user>/.sv
```

### systemd

<!-- TODO - add systemd user unit files to repository -->

https://wiki.archlinux.org/title/Systemd/User#Writing_user_units

## Check

You can check the status of the overlay by using the following:

```
firefox-overlay check
```

## Cache

Firefox writes cache data in `~/.cache/mozilla/firefox` which `firefox-overlay` doesn't handle.

You could solve this by adding the following to `/etc/fstab`:

```
tmpfs /home/<user>/.cache/mozilla/firefox tmpfs nosuid,nodev,size=1024M 0 0
```

## Related projects

* https://github.com/graysky2/profile-sync-daemon
