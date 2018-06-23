synology: file listings in user web
-----------------------------------

- enable in home service in : User -> Advanced

- user web directories should be accessible in http://my-ip/~myname

- for file listings:

-- open  sudo vim  /volume1/@appstore/WebStation/usr/local/etc/httpd/conf/extra/httpd-userdir.conf-user 

   ~~~~~~~~~~~ file: httpd-userdir.conf-user   ~~~~~~~~~
   LoadModule suphp_module modules/mod_suphp.so

   UserDir www

   <Directory "/var/services/homes/">
       AllowOverride Options=Indexes AuthConfig FileInfo Indexes Limit
       Options Indexes MultiViews +ExecCGI FollowSymLinks

   .....
   ~~~~~~~~~~~~~~~~~~~~~~


- insert 'Indexes'

