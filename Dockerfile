FROM node:8

# update distro and set timezone
ENV DEBIAN_FRONTEND noninteractive

RUN	apt-get -y update && \
	apt-get install -y --force-yes --no-install-recommends apt-utils wget curl net-tools && \
	apt-get clean all && \
	apt-get purge && \
	echo "America/Los_Angeles" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app

EXPOSE 3000
CMD [ "npm", "start" ]