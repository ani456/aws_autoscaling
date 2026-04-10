#!/bin/bash
yum update -y
yum install -y amazon-efs-utils

mkdir -p /mnt/efs

for i in {1..5}; do
  mount -t efs -o tls fs-xxxxxx:/ /mnt/efs && break
  echo "EFS mount failed, retrying..."
  sleep 10
done

chmod 777 /mnt/efs