# Using MySQL with reduced images

The images created by this software aim at deploying a MySQL server from several versions using a combination of two containers.

There are several images **datacharmer/mysql-minimal** with version 5.0, 5.1, 5.5, 5.6, 5.7, and 8.0.
Each image contains the latest tarball (or a very recent one) for the corresponding version.

As of its first releases (June-September 2016) we have:

* 5.0.96
* 5.1.72
* 5.5.52
* 5.6.33
* 5.7.15
* 8.0.00

The reduced tarballs are a cherrypick of tarballs distributed by MySQL, with only the files strictly needed to run a server, and the debug information stripped out. (See [distro-resize](https://github.com/datacharmer/mysql-docker-sandbox/tree/master/distro-resize) for more info.)

These images are deployed with a lightweight carrier, i.e. using BusyBox as the operating system. It is not supposed to run in that image (too many libraries are missing) but it allows you to run MySQL in the flavor of your choice without wasting too much space.

## Operations

To deploy an image, you need two steps.

With the first, you deploy the tarball **as a volume**

    $ docker create --name my_bin -v /opt/mysql  datacharmer/mysql-minimal-5.7

The path `/opt/mysql` contains the reduced tarball. It is deployed as a public volume, and the container is not running.

The second step is using the linux distribution of your choice. You may use any Linux distro, but then you'd have to install the server yourself. Instead, you use one of the following:

* `datacharmer/my-ubuntu`
* `datacharmer/my-debian`
* `datacharmer/my-centos`

Each one of these images has initialization code that can install a server from something found on /opt/mysql. For this to happen, you need to use the volume that was created in the previous step.

    $ docker run -ti --volumes-from my_bin --name mybox datacharmer/my-ubuntu bash
    ..
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 3
    Server version: 5.7.15 MySQL Community Server (GPL)

    Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> exit
    Bye

There is a bit going on behind the scenes. All the Linux distros have been configured with the minimum needed to run ALL VERSIONS of MySQL.

Notice that you don't need to specify a password. A non-trivial one is defined for you, and saved in /root/my.cnf. In later versions we will use a random password for this.

## Why this?

If you want to use MySQL on Docker, you can either try the "official" image (provided by the Docker team) using Debian, or the public image (provided by the MySQL team at Oracle) using OracleLinux. Neither of these options allow you to deploy MySQL 5.0 or 5.1.

Using a combination of these images, instead, you can decide which version you want, and which Linux flavor it will run into. 

## Why not Percona Server or MariaDB Server?

I am only including MySQL tarballs in this repository, for two good reasons:

* Percona Server tarballs require their own customized Linux host. While MySQL binaries run anywhere (because they are compiled statically) Percona creates different tarballs for different sets of libraries. This fact defies the purpose of having a reduced sets of Linux images that can run any version of MySQL. If there is an universal tarball for Percona Server, I would like to know.
* MariaDB 10.x has a different structure from MySQL and Percona servers. While I have one simple procedure to reduce the size of both MySQL and Percona servers, I would need to create a separate one for MariaDB. I haven't had the time to do it. If someone wants to contribute a set of reduced binaries, I will consider the inclusinon. The reduced binaries should be able to pass all the tests in MySQL-Sandbox to be included in this repository.

