FROM ubuntu
LABEL maintainer="xiaoming2020"

# 设置整个构建过程为非交互式
ARG DEBIAN_FRONTEND=noninteractive

# 1.首先下载必须的工具
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get autoclean \
    &&  apt-get install -y \
    python3 \
    libmysqlclient-dev \
    zsh \
    vim \
    git \
    make \
    g++ \
    cmake \
    net-tools \
    telnet \
    iputils-ping \
    wget \
    curl \
    tzdata \
    tcpdump \
    libboost-all-dev \
# 2.下面5个库解决git下载太慢和ssl的问题
    build-essential \
    nghttp2 \
    libnghttp2-dev \
    libssl-dev \
    gnutls-bin \
# 3.下面清除刚才更新带来的安装包等
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get autoclean \
# 4.git设置，
    && git config --global http.sslVerify false \
    && git config --global http.postBuffer 1048576000



# 6.美化终端，要求必须在vpn环境下进行，否则会下载失败
RUN chsh -s /bin/zsh \
    && sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting \
    && echo '# 命令高亮\nsource ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc \
    && /bin/zsh -c "source ~/.zshrc"

# 5.其他cpp开发环境需要的第三方库
RUN apt-get install -y \
    libfmt-dev \
    libspdlog-dev

# 6.vim设置，
RUN git clone https://github.com/Runner-2019/resource.git \
    && cd resource/script \
    && bash vim_install.sh \
    && cd ../.. \
    && rm -rf ./resource


# 8.cpp第三方库
# .1 nlohmann.json
RUN git clone https://github.com/nlohmann/json.git \
  && cd json \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make -j `nproc` \
  && make install \
  && cd ../.. \
  && rm -rf ./json

# .2 gflags
RUN git clone https://github.com/gflags/gflags.git \
  && cd gflags \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make \
  && make install \
  && cd ../.. \
  && rm -rf ./gflags

CMD ["/bin/zsh"]

