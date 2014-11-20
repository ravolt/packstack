# Packstack Barclamp for OpenCrowbar #

The Packstack workload for OpenCrowbar sets up an environment that can
run packstack.

# Install

Read this whole paragraph, please.  Per the instructions at [here](https://github.com/opencrowbar/core/blob/master/doc/deployment-guide/Install-CentOS-RHEL-6.5-AdminNode.md), you can install the rackn-packstack RPM before running production.sh but after running the crowbar-install.sh script.

The RPM can be found here: [RPM](http://opencrowbar.s3-website-us-east-1.amazonaws.com/rackn-packstack-2.0.0.6-1.noarch.rpm)

These two commands will install the OpenCrowbar tools.  Once that is done, you can run production.sh.

1. wget http://opencrowbar.s3-website-us-east-1.amazonaws.com/rackn-packstack-2.0.0.6-1.noarch.rpm
1. yum install -y rackn-packstack-2.0.0.6-1.noarch.rpm

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
1. boot admin node
1. Once admin node is ready, start 3-5 KVM machines.
  1. start 6 VMs: `for j in 1 2 3 4 5 6; do tools/kvm-slave & done`
1. Once these are discovered, use the ready-state wizard to set the following
  1. OS to centos7
  1. Nothing else.  Press apply.
  1. This takes you to the deploment screen.  DO NOT COMMIT
1. Go to the pilot deployment.
  1. Add roles, OpenStack (PackStack)
  1. Add Packstack to your controller node - it will add packstack-installer & client
  1. Edit the packstack-installer to choose your OpenStack release
  1. Add Packstack the result of your nodes - it will only add packstack-client 
  1. Commit deployment

Wait while everything happens - all node roles will be green at end.

1. Once done, get on the packstack-installer node.
  1. on admin, 
    1. `sudo ip a add 192.168.124.2/24 dev docker0`
    1. `su - crowbar`
    1. `ssh root@192.168.124.81`  (or which ever machine you choose for the packstack installer)
  1. on packstack installer node
    1. `su - packstack`
    1. `packstack --install-host=192.168.124.81,192.168.124.82,192.168.124.83 --use-epel=y --provision-demo=n`
    1. That command is for three nodes.  It will install icehouse nova with 192.168.124.81 as the controller node.

Wait for puppet installs to complete

1. Attach your desktop to the docker bridge: `sudo ip a add 192.168.124.2/24 dev docker0`
1. Get the credentials for your installation
   1. `exit` from the packstack user (you should now be root on the compute node)
   1. cat /home/packstack/admin_keystonerc
   1. go to [compute node](http://192.168.124.81) in web browser
   1. login using admin/credentials

When you are done, `for j in 1 2 3 4 5 6; do kill %$j ; done` to remove the VMs
