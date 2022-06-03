FROM ubuntu:22.04 as builder

RUN apt-get -qq update && \
    apt-get -qq install -y git \
    g++ make build-essential binutils cmake ninja-build \
    libssl-dev libboost-system-dev libcurl4-openssl-dev zlib1g-dev

WORKDIR /usr/local/walk-dog-telegram-bot
COPY include include
COPY src src
COPY tgbot-cpp tgbot-cpp
COPY CMakeLists.txt CMakeLists.txt

RUN cmake -S . -B build
RUN cmake --build build -j$(nproc)
RUN echo "build folder:" && ls build/

FROM ubuntu:22.04
LABEL version="0.0" maintainer="Igor Yadrov <yadrov@phystech.edu>"
RUN apt-get -qq update && \
    apt-get -qq install -y libssl-dev libboost-system-dev libcurl4-openssl-dev zlib1g-dev

WORKDIR /usr/local/walk-dog-telegram-bot
COPY --from=builder /usr/local/walk-dog-telegram-bot/build/bot ./
CMD ["./bot"]