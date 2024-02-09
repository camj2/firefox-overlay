# firefox-overlay

Redirect Firefox disk writes to a tmpfs backed [overlay](https://docs.kernel.org/filesystems/overlayfs.html).

Web browsers such as Firefox are known for writing excessive amounts of data to disk, even when running in the background. Disabling features such as crash recovery and disk cache do not solve the issue.

firefox-overlay solves this by mounting an overlay over `~/.mozilla/firefox` and storing the upper portion of the overlay on a tmpfs mountpoint. Once mounted, Firefox writes data to system memory rather than the underlying filesystem.

## Installation

```
git clone https://gitlab.com/camj/firefox-overlay
cd firefox-overlay
make
make install
```

## Configuration

### Backup

Before starting, optionally backup `~/.mozilla/firefox`:

```
cp -a --reflink=always ~/.mozilla/firefox ~/.mozilla/firefox-backup
```

### Overlay

firefox-overlay requires root permissions to mount/unmount the overlay.

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

* This is not required if `sudo`/`doas` are already configured in no password mode.

* If you installed firefox-overlay from your package manager, replace `/usr/local/bin` with `/usr/bin`.

### Daemon

Running firefox-overlay as a daemon is the recommended method to mount/unmount the overlay. Any data residing in the overlay will be flushed to disk when the daemon is terminated.

#### runit

Create a user based runit service by utilizing the included `firefox-overlay` service:

```
mkdir -p ~/.sv
cp -r init/runit/firefox-overlay ~/.sv/
```

Once done, add the following to your init script:

```
runsvdir /home/<user>/.sv
```

Verify the service is running:

```
sv status ~/.sv/firefox-overlay
```

<!-- #### systemd -->

<!-- TODO - add systemd user unit files to repository -->

<!-- https://wiki.archlinux.org/title/Systemd/User#Writing_user_units -->

### Cache

Firefox uses `~/.cache/mozilla/firefox` for cache files which firefox-overlay doesn't handle.

You could solve this by symlinking `~/.cache` to a tmpfs mountpoint.

#### runit

This can be accomplished by utilizing the included `cache` service:

```
cp -r init/runit/cache ~/.sv/
```

Verify the service is running:

```
sv status ~/.sv/cache
```

<!-- #### systemd -->

<!-- TODO - add systemd user unit files to repository -->

<!-- https://wiki.archlinux.org/title/Systemd/User#Writing_user_units -->

## Debug

### Usage

```
USAGE:
    firefox-overlay [SUBCOMMAND]

SUBCOMMANDS:
    m, mount      Mount overlay
    u, unmount    Unmount overlay
    f, flush      Flush overlay to disk
    c, check      Check overlay status
```

### Status

You can check the status of the overlay by using the following:

```
firefox-overlay check
```

## Related projects

* https://github.com/graysky2/profile-sync-daemon
