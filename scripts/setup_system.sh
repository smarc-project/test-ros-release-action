#!/bin/bash

# Example usage: ./setup_system.sh noetic
# Example usage: ./setup_system.sh melodic

# Install SMaRC ROS system
sudo curl https://raw.githubusercontent.com/smarc-project/rosinstall/master/sources.list.d/smarc-${1}-latest.list -o /etc/apt/sources.list.d/smarc-latest.list
sudo curl https://raw.githubusercontent.com/smarc-project/rosinstall/master/rosdep/50-smarc-${1}.list -o /etc/ros/rosdep/sources.list.d/50-smarc.list
sudo apt update
rosdep update

if [ "$1" == "melodic" ]; then
  sudo apt install -y python-bloom
else
  sudo apt install -y python3-bloom
fi

# Install necessary deps for bloom and deb packaging
sudo apt install -y fakeroot dpkg-dev debhelper zip
