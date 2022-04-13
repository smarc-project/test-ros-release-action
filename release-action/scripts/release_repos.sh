#!/bin/bash -e

# Example usage: ./release_repos.sh focal noetic
# Example usage: ./release_repos.sh bionic melodic

mkdir bloom-release-debs

pkgs_file="release_packages.yaml"
has_config=$(test -f "$pkgs_file" && echo true || echo false)
if $has_config; then
  echo "Found ${pkgs_file}"
  pkgs=()
  while read line; do
    echo $line
    pkgs+=($(echo $line | cut -c3-))
  done < $pkgs_file
else
  echo "Did not find ${pkgs_file}"
  pkgs=(".")
fi

echo ${pkgs[*]}

for pkg in ${pkgs[*]}; do
  echo "Doing ${pkg}"
  cd $pkg
  ls
  rosdep install --from-path . --ignore-src --rosdistro $2 -y
  bloom-generate rosdebian --os-name ubuntu --os-version $1 --ros-distro $2
  fakeroot debian/rules binary
  sudo dpkg -i ../ros-${2}-*.deb
  if $has_config; then
    cd ..
    mv ros-${2}-*.deb bloom-release-debs
  else
    mv ../ros-${2}-*.deb bloom-release-debs
  fi
done
zip -j bloom-${2}-release-deb.zip bloom-release-debs/*
ls
