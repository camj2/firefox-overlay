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

firefox-overlay requires root permissions to mount/unmount the overlay:

#### sudo

Add the following to `/etc/sudoers`:

```
<user> ALL=(ALL:ALL) NOPASSWD: /usr/local/bin/firefox-overlay-helper
```

#### doas

Add the following to `/etc/doas.conf`:

```
permit nopass <user> cmd /usr/local/bin/firefox-overlay-helper
```

### Daemon

Running firefox-overlay as a daemon is the recommended method to mount/unmount the overlay. Any data residing in the overlay will be flushed to disk when the daemon is terminated.

#### runit

Create a user, (non-root), runit service by utilizing the included `firefox-overlay` service:

```
mkdir -p ~/.sv
cp -r init/runit/firefox-overlay ~/.sv/
```

Once done, add the following to your init script:

```
runsvdir /home/<user>/.sv
```

Verify the service is running with:

```
sv status ~/.sv/firefox-overlay
```

### Cache

Firefox uses `~/.cache/mozilla/firefox` for cache files which firefox-overlay doesn't handle.

You could solve this by symlinking `~/.cache` to a tmpfs mountpoint.

#### runit

This can be accomplished by utilizing the included `cache` service:

```
cp -r init/runit/cache ~/.sv/
```

Verify the service is running with:

```
sv status ~/.sv/cache
```

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

### Memory

Check memory usage with:

```
firefox-overlay check
```

## Related projects

* https://github.com/graysky2/profile-sync-daemon
