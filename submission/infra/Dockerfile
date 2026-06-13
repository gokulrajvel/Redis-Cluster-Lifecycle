FROM ubuntu:22.04

# Avoid frontend prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install SSH server, sudo, python3, and development tools needed for Redis compilation later
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    wget \
    make \
    gcc \
    libc-dev \
    curl \
    tar \
    iproute2 \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH daemon settings
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/g' -i /etc/pam.d/sshd

# Setup root SSH directory
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Copy the host machine public key into authorization file
COPY id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Expose SSH, Redis, and Redis Cluster communication ports
EXPOSE 22 6379 16379

CMD ["/usr/sbin/sshd", "-D"]
