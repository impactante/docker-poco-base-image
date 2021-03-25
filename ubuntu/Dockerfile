FROM edsonsoares/poco:1.9-ubuntu

ENV DEBIAN_FRONTEND noninteractive

ENV CMAKE_DOWNLOAD_URL https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz
ENV CMAKE_SHA256 dc1246c4e6d168ea4d6e042cfba577c1acd65feea27e56f5ff37df920c30cae0

ENV BOOST_DOWNLOAD_URL https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.gz
ENV BOOST_SHA256 882b48708d211a5f48e60b0124cf5863c1534cd544ecd0664bb534a4b5d506e9

# ENV POCO_DOWNLOAD_URL https://github.com/pocoproject/poco/archive/poco-1.9.1-release.tar.gz
# ENV POCO_DOWNLOAD_SHA256 8d76989d8ba5a7080e6a14f9274ff22fda37906fb8991727c2639b26d901198b

RUN apt-get update -qq \
	&& apt-get install -yq software-properties-common python-software-properties \
	&& apt-add-repository ppa:ubuntu-toolchain-r/test \
	&& apt-get update \
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
		# apache2 \
		# apache2-dev \
		gcc-6 \
		g++-6 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6

# Download and install CMake 3.7.2
RUN curl -fsSL "${CMAKE_DOWNLOAD_URL}" -o /tmp/cmake.tar.gz \
    && echo "$CMAKE_SHA256  /tmp/cmake.tar.gz" | sha256sum -c - \
    && tar --directory /tmp -xzf /tmp/cmake.tar.gz \
    && cd /tmp/cmake-3.7.2 && ./configure \
    && make && make install \
    && rm -rf /tmp/cmake-3.7.2 /tmp/cmake.tar.gz

# Install Poco C++ Libraries 1.9.1
# RUN curl -fsSL "${POCO_DOWNLOAD_URL}" -o /tmp/poco.tar.gz \
#	&& echo "$POCO_DOWNLOAD_SHA256  /tmp/poco.tar.gz" | sha256sum -c - \
#	&& tar --directory /tmp -xzf /tmp/poco.tar.gz \
#	&& cd /tmp/poco-poco-1.9.1-release && cmake . \
#		-DENABLE_TESTS=OFF \
#		-DENABLE_APACHECONNECTOR=ON \
#	&& make && make install \
#	&& rm /tmp/poco.tar.gz

# Download and install Boost 1.7
RUN curl -fsSL "${BOOST_DOWNLOAD_URL}" -o /tmp/boost_1_70_0.tar.gz \
    && echo "$BOOST_SHA256  /tmp/boost_1_70_0.tar.gz" | sha256sum -c - \
    && tar --directory /tmp -xzf /tmp/boost_1_70_0.tar.gz \
    && cd /tmp/boost_1_70_0 && ./bootstrap.sh --with-libraries=program_options,system,locale,filesystem,chrono,thread \
    && ./b2 --link=shared --runtime-link=shared --variant=release \
    && ./b2 install \
    && rm -rf /tmp/boost_1_70_0 /tmp/boost_1_70_0.tar.gz

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

EXPOSE 80
CMD ["/usr/sbin/apachectl", "-DFOREGROUND"]
