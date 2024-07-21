Title: Running the ArchiveTeam Warrior under Podman
Date: 2024-07-08 03:48:43
Category: Tech
Tags: archiveteam, warrior, podman, quadlet, systemd, bandwidth

I'm finally back on an unlimited internet connection, so I've started
running the [ArchiveTeam Warrior](https://wiki.archiveteam.org/index.php/ArchiveTeam_Warrior) once again.

The Warrior is a software application for archiving websites in a crowdsourced
manner, especially when there's a time crunch when a website announces that
it's closing or planning to delete things. Currently the default project is to archive
[public Telegram channels](https://wiki.archiveteam.org/index.php/Telegram).

Historically the Warrior was distributed as a VirtualBox appliance, which was
a bit annoying to run headlessly and was unnecessarily resource intensive because
it required full virtualization. But they now have a [containerized version](https://wiki.archiveteam.org/index.php/Running_Archive_Team_Projects_with_Docker)
that is pretty trivial to set up.

Relatedly, I've recently been playing with Podman's "[Quadlet](https://blogs.gnome.org/alexl/2021/10/12/quadlet-an-easier-way-to-run-system-containers/)" functionality, which I really, really like. Instead of needing
to create a systemd service to wrap running a container, you can specify what you want to run in a basically systemd-native way:

```ini
[Unit]
Description=warrior

[Container]
Image=atdr.meo.ws/archiveteam/warrior-dockerfile

PublishPort=8001:8001

Environment=DOWNLOADER=<your name>
Environment=SELECTED_PROJECT=auto
Environment=CONCURRENT_ITEMS=4

AutoUpdate=registry

[Service]
Restart=on-failure
RestartSec=30
# Extend Timeout to allow time to pull the image
TimeoutStartSec=180

[Install]
# Start by default on boot
WantedBy=multi-user.target default.target
```

I substituted in my username and dropped this into `~/.config/containers/systemd/warrior.container`, ran
`systemctl --user daemon-reload` and `systemctl --user start warrior` and
it immediately started archiving! Visiting `localhost:8001` should bring
up the web interface.

You can then run `systemctl --user cat warrior` to see what the generated
`.service` file looks like.

The `AutoUpdate=registry` line tells [`podman-auto-update`](https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html) to automatically fetch
image updates and restart the running container. You'll likely need to enable/start the timer for this, with `systemctl --user enable podman-auto-update.timer`.

The one thing I haven't figured out yet is gracefully shutting down, which is
important to avoid losing unfinished data. I suspect the `Restart=always` is harmful here,
since I do want to explicitly shutdown in some cases.

P.S. I also have a infrequently updated [Free bandwidth](https://legoktm.com/view/Free_bandwidth)
wiki page that contains other suggestions for how to use your internet connection for good.

Update (2024-07-14): I changed the restart options to `Restart=on-failure` and `RestartSec=30`, which fixes the issue with restarting immediately
after a graceful shutdown and correctly restarting if it starts up before networking is ready.
