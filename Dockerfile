# Dockerfile for rpi-mjpg-streamer

# https://www.balena.io/docs/reference/base-images/base-images-ref/
ARG RPI=raspberrypi3

FROM balenalib/$RPI-debian:latest

WORKDIR /

# install packages
RUN apt-get update -y && \
		apt-get install -y build-essential libjpeg8-dev imagemagick libv4l-dev git cmake uvcdynctrl libraspberrypi-bin

# build mjpg-streamer
RUN ln -s /usr/include/linux/videodev2.h /usr/include/linux/videodev.h && \
		git clone https://github.com/jacksonliam/mjpg-streamer && \
		cd mjpg-streamer/mjpg-streamer-experimental && \
		cmake -DCMAKE_INSTALL_PREFIX:PATH=.. . && \
		make install

# copy rpi-mjpg-streamer files
COPY ./ /

# arguments (default values in `.env` file)
ARG PORT
ARG RESOLUTION
ARG FPS
ARG ANGLE
ARG FLIPPED
ARG MIRRORED
ARG USERNAME
ARG PASSWORD

# environtment variables
ENV PORT=${PORT} \
		 RESOLUTION=${RESOLUTION} \
		 FPS=${FPS} \
		 ANGLE=${ANGLE} \
		 FLIPPED=${FLIPPED} \
		 MIRRORED=${MIRRORED} \
		 USERNAME=${USERNAME} \
		 PASSWORD=${PASSWORD}

# configure
RUN echo "{'angle': ${ANGLE}, 'flipped': ${FLIPPED}, 'mirrored': ${MIRRORED}}" \
		> /www/config.json

# Open ports
EXPOSE $PORT

# Entry point for the built application
ENTRYPOINT ["/run-mjpg-streamer.docker.sh"]
