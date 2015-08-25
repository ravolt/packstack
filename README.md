# Packstack Barclamp for OpenCrowbar #

The Packstack workload for OpenCrowbar sets up an environment that can
run packstack.
The RPM can be found here: [RPM](http://opencrowbar.s3-website-us-east-1.amazonaws.com/rackn-packstack-2.0.0.9-1.noarch.rpm) if you would like to download it directly.

# Install

Read this whole paragraph, please. 

1. Follow the regular OpenCrowbar installation instructions at [here](https://github.com/opencrowbar/core/blob/master/doc/deployment-guide/Install-CentOS-RHEL-6.5-AdminNode.md).  But do not run the production.sh script (The last step)

2. wget http://opencrowbar.s3-website-us-east-1.amazonaws.com/rackn-packstack-2.0.0.9-1.noarch.rpm

3. yum install -y rackn-packstack-2.0.0.9-1.noarch.rpm

4. NOW you can run production.sh.  /opt/opencrowbar/core/production.sh &lt;FQDN of the admin node&gt;

# Use

The *packstack-installer* role can be added to nodes to generate a place
to run packstack.
The *packstack-client* role can be added to nodes to indicate a node
that should participate in the packstack configured cluster.

The packstack-installer role will generate a user account to run
packstack from.  The user can already exist, e.g. root, or a new one
specified.  The default is *packstack*.  This can be overriden in the
node-role for this instance.  The attribute is *packstack-user*.  The
node-role also allows for the specification of the openstack release.
The default is icehouse, but juno can be specified.  At the moment,
that appears to be juno-1.  The attribute is *packstack-openstack_release*.

The packstack-client will add the public key from all
*packstack-installer* roles' users.  The node will also have the
network-manager disabled is present.

Once all the roles are applied, log into a *packstack-installer* node
and change to the *packstack-user*.  From this account, you can run
packstack.

Something like this could be used on a 3 node default setup:
packstack --install-host=192.168.124.81,192.168.124.82,192.168.124.83
--use-epel=y --provision-demo=n

## Steps: 
1. boot admin node (The "System" Deployment is complete)
1. Once admin node is ready, start 3-5 Nodes.
1. Once these are discovered, (show green in the system deployment) use the ready-state wizard to set the following
  1. OS to centos7
  1. Ensure that the Network is how you would like it set up.
  1. Click "Run Wizard"
  1. This takes you to the deploment screen.  *DO NOT COMMIT*
1. Go to the pilot deployment.
  1. Add roles, OpenStack (PackStack)
  1. Add Packstack to your controller node (Click on the +) - it will add packstack-installer & client
  1. Edit the packstack-installer to choose your OpenStack release
  1. Add Packstack the rest of your nodes - it will only add packstack-client 
  1. Commit deployment

Wait while everything happens - all node roles will be green at end.

1. Once done, onto the packstack-installer node.
  1. on admin, 
    1. `sudo ip a add 192.168.124.2/24 dev docker0` *ONLY NEEDED IF YOU ARE RUNNING IN DOCKER CONTAINERS*
    1. `su - crowbar`
    1. `ssh root@192.168.124.81`  (or which ever machine you choose for the packstack installer)
  1. on packstack installer node
    1. `su - packstack`
    1. `packstack --install-host=&lt;IP Addresses of your systems&gt; --use-epel=y --provision-demo=n`
    1. That command is for three nodes.  It will install icehouse nova with 192.168.124.81 as the controller node.

Wait for puppet installs to complete

1. Attach your desktop to the docker bridge: `sudo ip a add 192.168.124.2/24 dev docker0` *ONLY NEEDED IF YOU ARE RUNNING IN DOCKER CONTAINERS*
1. Get the credentials for your installation
   1. `exit` from the packstack user (you should now be root on the compute node)
   1. cat /home/packstack/admin_keystonerc
   1. go to [compute node](http://192.168.124.81) in web browser
   1. login using admin/credentials


