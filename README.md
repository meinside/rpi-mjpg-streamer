# rpi-mjpg-streamer

Instructions and helper scripts for running mjpg-streamer on Raspberry Pi.


## A. Setup mjpg-streamer

### Enable Raspberry Pi Camera module from raspi-config

```bash
$ sudo raspi-config
```

### Install necessary packages for mjpg-streamer

```bash
$ sudo apt-get update
$ sudo apt-get install build-essential libjpeg-dev imagemagick libv4l-dev git cmake uvcdynctrl
```

### Build mjpg-streamer

```bash
$ sudo ln -s /usr/include/linux/videodev2.h /usr/include/linux/videodev.h
$ git clone https://github.com/jacksonliam/mjpg-streamer
$ cd mjpg-streamer/mjpg-streamer-experimental
$ cmake -DCMAKE_INSTALL_PREFIX:PATH=.. .
$ make install
```

### Setup video4linux for Raspberry Pi Camera module

```bash
$ sudo modprobe bcm2835-v4l2
$ sudo vi /etc/modules

# add following line:
bcm2835-v4l2

$ sudo vi /boot/config.txt

# add following line if you want to disable RPi camera's LED:
disable_camera_led=1
```

### Add yourself to the video group

```bash
$ sudo usermod -a -G video $USER
```

## B. Run mjpg-streamer

### 1. Clone this repository

```bash
$ git clone https://github.com/meinside/rpi-mjpg-streamer.git
```

### 2-a. Run mjpg-streamer from the shell directly

```bash
# copy & edit run-mjpg-streamer.sh to your environment or needs
$ cp rpi-mjpg-streamer/run-mjpg-streamer.sh.sample somewhere/run-mjpg-streamer.sh
$ vi somewhere/run-mjpg-streamer.sh

# then run
$ somewhere/run-mjpg-streamer.sh
```

### 2-b. Run mjpg-streamer as a service

#### systemd

```bash
# copy & edit systemd/mjpg-streamer.service file,
$ sudo cp rpi-mjpg-streamer/systemd/mjpg-streamer.service.sample /lib/systemd/system/mjpg-streamer.service
$ sudo vi /lib/systemd/system/mjpg-streamer.service

# then register as a service
$ sudo systemctl enable mjpg-streamer.service

# or remove it
$ sudo systemctl disable mjpg-streamer.service

# and start/stop it
$ sudo systemctl start mjpg-streamer.service
$ sudo systemctl stop mjpg-streamer.service
```

### 3. Or run with docker

With docker, you don't have to build mjpg-streamer manually.

#### (A) With docker

Build with essential build arguments, (see the argument names and sample values in [.env](https://github.com/meinside/rpi-mjpg-streamer/blob/master/.env) file)

```bash
$ docker build -t streamer:latest \
		--build-arg PORT=9999 \
		--build-arg RESOLUTION=400x300 \
		--build-arg FPS=24 \
		--build-arg ANGLE=0 \
		--build-arg FLIPPED=false \
		--build-arg MIRRORED=false \
		--build-arg USERNAME=user \
		--build-arg PASSWORD=some-password \
		.
```

then run with:

```bash
$ docker run -p 9999:9999 --device /dev/video0 -it streamer:latest
```

#### (B) With docker-compose

Build with optional build arguments, (see the argument names and default values in [.env](https://github.com/meinside/rpi-mjpg-streamer/blob/master/.env) file)

```bash
# build with the default values
$ docker-compose build

# or with custom values
$ docker-compose build --build-arg PORT=9999 --build-arg USERNAME=user --build-arg PASSWORD=some-password
```

then run with:

```bash
$ docker-compose up -d
```

If you set custom port number, you should run with that value:

```bash
$ PORT=9999 docker-compose up -d
```

## C. Connect

Connect through the web browser:

![Connected](https://cloud.githubusercontent.com/assets/185988/2740477/3501d5b0-c6d3-11e3-85de-de3ceb302325.png)

Most modern browsers(including mobile browsers like Safari and Chrome) will show the live stream immediately.

