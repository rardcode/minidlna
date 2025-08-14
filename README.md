# MiniDLNA
MiniDLNA server based on Alpine Linux.

## Quick reference
* Where to file issues:
[GitHub](https://github.com/rardcode/minidlna)

* Supported architectures: amd64 , armv7 , arm64v8

## How to use

Declare env and relative volumes:

IMPORTANT: Declaring more media dirs with incremental numbers.

```
-e media_1=P,/media/photos
-e media_2=V,/media/video
-v /srv/photos:/media/photos
-v /srv/videos:/media/videos
```
or...mount a single volume for example `-v /srv/collection:/media/collection` and declare the corresponding variables by subdirectory, for example
```
-e media_1=P,/media/collection/photos \
-e media_2=V,/media/collection/videos \
```
### ...by docker run:
```
docker run --rm -d \
--net host \
-e media_1=P,/media/photos \
-v /srv/photos:/media/photos \
--name minidlna rardcode/minidlna
```

### ...by docker-compose file:
```
services:
  minidlna:
    image: rardcode/minidlna
    container_name: minidlna
    environment:
    - media_1=P,/media/photos
    volumes:
    - /srv/photos:/media/photos
    - /etc/timezone:/etc/timezone:ro
    - /etc/localtime:/etc/localtime:ro
    # You need to run the container in host mode for it to be able to receive UPnP broadcast packets. The default bridge mode will not work.
    network_mode: host
    restart: unless-stopped
```

## Envs
```
mdPort="8200" # default = 8200
mdFriendlyname="Alpine DLNA Server"
mdInotify="no" # default = yes
mdEnabletivo="yes" # default = no
mdStrictdlna="yes" # default = no
mdNotifyinterval="895"# default = 895
```

## Media dirs
Type of media legend:
```
"A" for audio  (eg. media_dir=A,/home/jmaggard/Music)
"V" for video  (eg. media_dir=V,/home/jmaggard/Videos)
"P" for images (eg. media_dir=P,/home/jmaggard/Pictures)
"PV" for pictures and video (eg. media_dir=PV,/home/jmaggard/digital_camera)
```

## Changelog
v1.0.1 - 14.08.2025
- Alpine v. 3.22.1
- minidlna v. 1.3.3-r1

v1.0.0 - 25.06.2025
- Alpine v. 3.22.0
- minidlna v. 1.3.3-r1
