General Set Up

2.1 httpd
$ sudo systemctl start httpd

Make sure the httpd service always starts after a reboot:
$ sudo systemctl enable httpd

2.2 Confirm that httpd is running
http://127.0.0.1
Should get an Apache test page

2.3 HTML
Code simple html webpage
Design a simple HTML webpage that says welcome and contains a link to a userid and
password protected page:
<html>
<p> Welcome ! </p>
<a href="http://127.0.0.1/protected/index.html">Protected
area</a>
</html>
Note: You need to be root to create files in /var/www.
Save it as:
/var/www/html/index.html
Verify that your new index.html page is working:
http://127.0.0.1/
If you have created the index.html file with a GUI application like Notepadqq, you will
need to save the index.html file in a temporary location like:
/home/sat3310/Documents/labs/lab07/index.html
And then move it manually with:
$ sudo mv /home/sat3310/Documents/labs/lab07/index.html
/var/www/html/index.html
Finally set the correct ownership with:
$ sudo chown root:root /var/www/html/index.html
Note: If you are getting “Forbidden” when trying to access your website at
http://127.0.0.1/
You may need to jump ahead to section 2.11 and disable SELinux.

2.4 SS Take a screenshot of your website
2.5 Security – htaccess
Create a new directory:
$ sudo mkdir -p /var/www/html/protected

2.6 Design a simple HTML webpage that says:
<html>
<p> Welcome authenticated user ! <p>
</html>
Save it as:
/var/www/html/protected/index.html
Verify that your new index.html page is working:
http://127.0.0.1/protected
If you have created the index.html file with a GUI application like Notepadqq, you will
need to save the index.html file in a temporary location like:
/home/sat3310/Documents/labs/lab07/index.html
And then move it manually with:
$ sudo mv /home/sat3310/Documents/labs/lab07/index.html
/var/www/html/protected/index.html
Finally set the correct ownership with:
$ sudo chown root:root /var/www/html/protected/index.html

2.7 htaccess - configuration
Recall the folder:
/etc/httpd/conf.d
Any file in that folder ending in *.conf will be loaded as an Apache configuration.
What that means is you can simple create a small configuration file that will be added to main
configuration file upon httpd startup.
In our situation, we want to add some special considerations to the folder
/var/www/html/protected

2.8 Create a new configuration file:
/etc/httpd/conf.d/protected.conf
And include the following lines:
<Directory /var/www/html/protected>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
allow from all
</Directory>
Finally set the correct ownership with:
$ sudo chown root:root /etc/httpd/conf.d/protected.conf

2.9 mod_auth
Look in your httpd.conf file and make sure the module
mod_auth_basic
is being loaded.
Hint: modules are being loaded in the file:
/etc/httpd/conf.modules.d/00-base.conf
In that file you can look for:
LoadModule auth_basic_module modules/mod_auth_basic.so

2.10 .htaccess
In the folder:
/var/www/html/protected
make a new file called
.htaccess
Note: in the AuthUserFile directive, you will create the .htpasswd file in the next section.
And add the following lines:
AuthName "Protected Area. Authentication required!"
AuthUserFile /var/www/html/protected/.htpasswd
AuthType Basic
Require valid-user

2.11 SELinux
Note: You may need to make sure SElinux is disabled:
$sudo vi /etc/sysconfig/selinux
and change the line
SELINUX=enforcing
to
SELINUX=disabled
You will need to reboot you system for the new SElinux policy to take affect.

2.12 Restart httpd
You can test if the configuration is working by restarting httpd.
$ sudo systemctl restart httpd
Be sure to restart your client web browser also.
Attempt to browse to the "Authenticated Users Only" link. It should ask for credentials.

2.13 SS Take a screenshot of your webserver asking for credentials

2.14 htpasswd
In this section you will create a new .htpasswd file that contains just the userid and encrypted
passwd.
You can add users with the htpasswd command.
For example:
$ sudo htpasswd -c /var/www/html/protected/.htpasswd todd
Now set the password to
password
For example:
[root@localhost httpd]# htpasswd -c
/var/www/html/protected/.htpasswd todd
New password:
Re-type new password:
Adding password for user todd
You can test if the configuration is working by restarting httpd and browsing to the protected
webpage.
$ sudo systemctl restart httpd
Go to the webpage
http://127.0.0.1/protected
And make sure you can successfully enter the userid and password credentials you created
earlier.
If successful, you should see your new webpage. For example:
Welcome authenticated user !

2.15 SS Take a screenshot of the protected webpage.