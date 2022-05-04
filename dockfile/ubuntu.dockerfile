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
# 3.其他cpp开发环境需要的可直接下载的第三方库
    libfmt-dev \
    libspdlog-dev \
# 4.下面清除刚才更新带来的安装包等
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get autoclean \
# 5.git设置，
    && git config --global http.sslVerify false \
    && git config --global http.postBuffer 1048576000 \
# 6.美化终端，要求必须在vpn环境下进行，否则会下载失败
    && chsh -s /bin/zsh \
    && sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting \
    && echo '# 命令高亮\nsource ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc \
    && /bin/zsh -c "source ~/.zshrc" \
# 7.vim设置，终端的配置文件复制和主题替换
    && git clone https://github.com/Runner-2019/resource.git \
    && cd resource/config \
    && rm -f ~/.zshrc \
    && cp zshrc  ~/.zshrc \
    && cd ../script \
    && bash vim_install.sh \
    && git clone  --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
    && cd ../.. \
    && rm -rf ./resource \
# 8.cpp第三方库
# 8.1 nlohmann.json
    && git clone https://github.com/nlohmann/json.git \
    && cd json \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j `nproc` \
    && make install \
    && cd ../.. \
    && rm -rf ./json \
# 8.2 gflags
    && git clone https://github.com/gflags/gflags.git \
    && cd gflags \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && cd ../.. \
    && rm -rf ./gflags

CMD ["/bin/zsh"]

