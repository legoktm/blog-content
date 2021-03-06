Title: Accidentally creating a server in the wrong datacenter
Date: 2021-03-06 05:20:08
Category: MediaWiki
Tags: wikimedia, sre, validation

Yesterday I was working on upgrading the servers that power [Wikimedia's Docker registry](https://docker-registry.wikimedia.org/) (see [T272550](https://phabricator.wikimedia.org/T272550)). Since these are virtual machines, I was just creating new ones and going to delete the old ones later (because [VMs are cattle, not pets](https://bash.toolforge.org/quip/AU_Tlz8f1oXzWjit5jiA)).

We have a handy script to create new VMs, so I ran the following command:

<code>legoktm@cumin1001:~$ sudo cookbook sre.ganeti.makevm --vcpus 2 --memory 4 --disk 20 codfw_B registry2004.eqiad.wmnet</code>

In this command <code>codfw_B</code> refers to the datacenter and row to create the VM in, and <code>registry2004.eqiad.wmnet</code> is the requested fully qualified domain name (FQDN).

If you're familiar with [Wikimedia's datacenters](https://wikitech.wikimedia.org/wiki/Clusters), you'll notice that I created the VM in codfw (Dallas) and gave it a name as if it were in eqiad (Virginia). Oops. I only noticed right as the script finished creation. (Also the 2XXX numbering is for codfw. 1XXX servers are in eqiad.)

Normally we have a [decommissioning script](https://wikitech.wikimedia.org/wiki/Decom_script) for deleting VMs, but when I tried running it, it failed because the VM hadn't fully been set up in Puppet yet!

Then I tried just adding it to puppet and continuing enough of the VM setup that I could delete it, except our CI correctly [rejected my attempt to do so](https://gerrit.wikimedia.org/r/c/operations/puppet/+/668571) because the name was wrong! I was stuck with a half-created VM that I couldn't use nor delete.

After a quick break (it was frustrating), I read through the decom script to see if I could just do the steps manually, and realized the error was probably just a bug, so I [submitted a one-line fix](https://gerrit.wikimedia.org/r/c/operations/cookbooks/+/668572) to allow me to delete the VM. Once it was merged and deployed, I was able to delete the VM, and actually create what I wanted to: <code>registry2004.codfw.wmnet</code>.

Really, we should have been able to catch this when I entered in the command, since I specified the datacenter even before the FQDN. After [some discussion in Phabricator](https://phabricator.wikimedia.org/T276516), I submitted a [patch to prevent such a mismatch](https://gerrit.wikimedia.org/r/c/operations/cookbooks/+/668867/). Now, the operator just needs to specify the hostname, <code>registry2004</code>, and it will build the FQDN using the datacenter and networking configuration. Plus it'll prompt for user confirmation that it was built correctly. (For servers that use numbers afterwards, it'll check those too.)

Once this is deployed, it should be impossible for someone to repeat my mistake. Hopefully.

