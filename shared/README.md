# deliberation-infrastructure

Holds components that are shared between different services, things that we don't take down even if the services themselves are taken down.

# Network

Use a single vpc for everything.

### Load balancer

We define one load balancer for all traffic coming in under any subdomain.
Traffic to these subdomains gets redirected to the appropriate services.

### Security Groups

We define a single security group to be used by the different containerized applications
that allows them to access the file store

### File storage

We define one file storage volume that will be accessed by all of the services.
This volume is backed up to S3 hourly.
