Storing credentials

Create a secrets file to store credentials for a WebDAV-service using ~/.davfs2/secrets for user, and /etc/davfs2/secrets for root:

/etc/davfs2/secrets

http(s)://address:<port>/path username password

Make sure the secrets file contains the correct permissions:

# chmod 600 /etc/davfs2/secrets
# chown root:root /etc/davfs2/secrets

For user mouting:

$ chmod 600 ~/.davfs2/secrets

