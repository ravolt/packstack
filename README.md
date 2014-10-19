# Packstack Barclamp for OpenCrowbar #

The Packstack workload for OpenCrowbar sets up an environment that can
run packstack.


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


