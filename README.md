knife-github-cookbooks
======================

Description
-----------

A knife plugin facilitating installing, updating, and tracking cookbooks found
Github.

Installation
------------

    gem install knife-github-cookbooks

Motivation
----------

The current "repo of cookbooks" pattern of sharing neglects Chef's core unit
of currency: the cookbook. Excellent cookbooks that developers have labored
over for hours are lost in the sea of forks of `opscode/cookbooks`, hidden
from the prying eyes of Google. Just look at this mess:

https://github.com/opscode/cookbooks/network/members

There's also the Opscode Community, which presents users with a cookbook, but
no way to see what it contains without downloading a tarball. This feels
vauguely like ... SourceForge.

For pete's sake, folks, I thought this was DevOps! I'm a developer. I spend
hours on Github everyday. Cookbooks should be individual Github repos, with
all of the bells and whistles that come along with it. The network graph! Pull
requests! Issues! The tools of a developer! Tarballs? Tarballs are what a
smelly sysadmin downloads between games of Quake.

The hedgehog knows what I'm talking about:

https://github.com/cookbooks

And this:

https://github.com/papercavalier/mongodb-cookbook/network

Usage
-----

### Installing Cookbooks

Say you wanted to install the `yum` cookbook located at
https://github.com/cookbooks/yum. To do so, you'd run the following command:

    knife cookbook github install cookbooks/yum

The repo at https://github.com/cookbooks/yum will be cloned into a temporary
directory, moved into `cookbooks/yum` using the familiar vendor branch
pattern, and the resulting files committed into the repo with a log message
like so:

    Import cookbooks/yum version 8c6f4082482b5f9d93e9b8256c23a7add03aa0fb

By default, the public `git://` URI will be used. To clone a private repo via
the `git@` URI, pass the `-S` option:

    knife cookbook github install my_stealthy_startup/secret_sauce -S

### Tracking Cookbook Changes

Say you've seen some activity on one of the cookbooks you're using and you
want to see what's new. There's magic for that too! Say you installed
papercavalier's mongodb cookbook on May 1st, and want to see what's new. When
you run the following command:

    knife cookbook github compare mongodb

The local git log will be parsed to see what revision the cookbook was at when
it was installed, and the Github compare view will be launched:

https://github.com/papercavalier/mongodb-cookbook/compare/9d413996b3db93f94bafc462e6dbdb092fac534a...master

If you want to get up to date, another quick call to the install command will
get the cookbook updated:

    knife cookbook github install papercavalier/mongodb-cookbook

But wait! Say you've noticed that someone (in this case, `erkki`) has forked
the mongo cookbook. To see what they've added, just run the following:

    knife cookbook github compare mongodb erkki

https://github.com/papercavalier/mongodb-cookbook/compare/9d413996b3db93f94bafc462e6dbdb092fac534a...erkki:master

### Working with branches other than master

If someone's made changes in another branch, you can compare the changes like
so:

    knife cookbook github compare mongodb jnewland/fix-bug

Then install those changes like so:

    knife cookbook github install jnewland/mongodb/fix-bug

Epic. The tools of a developer.

Conventions
-----------

This plugin only supports installing repositories that contain a single
repository at the top-level. I do not plan to support installing cookbooks
contained in a repository like `opscode/cookbooks`, because I feel this
is a broken pattern for storing and sharing cookbooks.

If the repo you're trying to install is prefixed or suffixed with `chef`
and/or `cookbook`, this will be stripped from the repo name. For example, 
running:

    knife cookbook github install my_stealthy_startup/chef-nosql_cookbook

...will create the cookbook in the `cookbooks/nosql` directory.

Caveats
-------

This plugin does not support automatically fetching cookbook dependencies,
since version constraints are numeric and cookbook names can't specify the
Github user. If you have an clever ideas for how this should work, hit me up.

Requirements
------------

* `git`
* `chef ~> 0.10.0`

Author
------

Jesse Newland  
jesse@websterclay.com  
@jnewland  
jnewland on freenode  

License
-------

    Author:: Jesse Newland (<jesse@websterclay.com>)
    Copyright:: Copyright (c) 2011 Webster Clay, LLC
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.