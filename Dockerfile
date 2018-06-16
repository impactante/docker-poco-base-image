FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV POCO_DOWNLOAD_URL https://pocoproject.org/releases/poco-1.9.0/poco-1.9.0-all.tar.gz
ENV POCO_DOWNLOAD_SHA256 0387bf0f9d313e2311742e1ad0b64e07f2f3e76039eed20e3b9aa9951b88e187

RUN apt-get update -qq \
	&& apt-get install -yq software-properties-common python-software-properties \
	&& apt-add-repository ppa:ubuntu-toolchain-r/test \
	&& apt-get update \
	# Install CMake 3.7.2, GCC/G++ 6 and other dependencies
	&& apt-get install -yq --no-install-recommends \
		curl \
		libssl-dev \
		apt-utils \
		build-essential \
		unixodbc \ 
		unixodbc-dev \
		ca-certificates \
		libncurses-dev \
		libmysqlclient-dev \
		pkg-config \
		cmake \
		gcc-6 \
		g++-6 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6 \
			\
	# Install Poco C++ Libraries 1.9.0
	&& curl -fsSL "${POCO_DOWNLOAD_URL}" -o /tmp/poco.tar.gz \
	&& echo "$POCO_DOWNLOAD_SHA256  /tmp/poco.tar.gz" | sha256sum -c - \
	&& tar --directory /tmp -xzf /tmp/poco.tar.gz \
	&& cd /tmp/poco-1.9.0-all && ./configure --no-tests --no-samples --everything \
	&& make && make install \
	&& rm /tmp/poco.tar.gz

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

CMD ["/bin/bash"]