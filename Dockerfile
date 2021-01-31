FROM ubuntu:14.04

MAINTAINER Yanmei Zhao "zhaoymx@gmail.com"
ENV REFRESHED_AT 2020-10-17

ENV HOME /home/yanmei
WORKDIR $HOME

SHELL ["/bin/bash", "-c"]

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update && \ 
    DEBIAN_FRONTEND=noninteractive apt-get install -y \ 
    firefox vim tmux gedit\
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*


### install ros ###
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \ 
    > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key \ 
    C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update && \ 
    DEBIAN_FRONTEND=noninteractive apt-get install -y dpkg && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ros-indigo-desktop-full && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update


RUN echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc && \
    source ~/.bashrc

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y python-rosinstall && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*



### Replace 1000 with your user / group id
RUN export uid=502 gid=20 && \
    mkdir -p /home/yanmei && \
    echo "yanmei:x:${uid}:${gid}:Yanmei:/home/yanmei:/bin/bash" >> /etc/passwd && \
    echo "yanmei:x:${uid}:" >> /etc/group && \
    echo "yanmei ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/yanmei && \
    chmod 0440 /etc/sudoers.d/yanmei && \
    chown ${uid}:${gid} -R /home/yanmei

USER yanmei
ENV HOME /home/yanmei



ENTRYPOINT ["/bin/bash"]

