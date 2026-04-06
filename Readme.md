#Hosting a wordpress website with Autoscaling and LoadBalancing

This project is about hosting a wordpress website with Autoscaling and LoadBalancing on AWS. The project is divided into three parts:

www-data : is the default webserver(apache & nginx) user on systems like ubuntu

wp-config.php : is the main cofiguration file for wordpress, copy the sample wp-sample-config.php to wp-config.php and edit as per requirements

create new wordpress.conf file in the sites-available folder of apache2 which tells Apache when a request comes in, where should I send it and how should I handle it?

Create a virtual host in it

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

**ErrorLog** — records all errors (PHP errors, missing files, crashes) to a log file

- **CustomLog** — records every single visit/request to your site

using ami with launch templates for autoscaling

#traditonally used nfs-common
#apt install nfs-common
#mount -t nfs4 192.168.102.11:/home/nfsshare /mnt/nfserver/
#mount type, nfs serverpath,mount point at nfs client
