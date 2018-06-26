FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV POCO_DOWNLOAD_URL https://github.com/pocoproject/poco/archive/poco-1.9.0-release.tar.gz
ENV POCO_DOWNLOAD_SHA256 45ec5c759d2ad02bb812745f6cb585aa04af025c921b1bb4bdefa108ce4f1756

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
		pkg-config \
		apache2 \
		apache2-dev \
		cmake \
		gcc-6 \
		g++-6 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6

# Install Poco C++ Libraries 1.9.0
RUN curl -fsSL "${POCO_DOWNLOAD_URL}" -o /tmp/poco.tar.gz \
	&& echo "$POCO_DOWNLOAD_SHA256  /tmp/poco.tar.gz" | sha256sum -c - \
	&& tar --directory /tmp -xzf /tmp/poco.tar.gz \
	&& cd /tmp/poco-poco-1.9.0-release && cmake . \
		-DENABLE_DATA_ODBC=OFF \
		-DENABLE_DATA_MYSQL=OFF \
		-DENABLE_PAGECOMPILER=OFF \
		-DENABLE_MONGODB=OFF \
		-DENABLE_PAGECOMPILER=OFF \
		-DENABLE_TESTS=OFF \
		# -DENABLE_APACHECONNECTOR=ON \
	&& make && make install \
	&& rm /tmp/poco.tar.gz

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

EXPOSE 80
CMD ["/usr/sbin/apachectl", "-DFOREGROUND"]
