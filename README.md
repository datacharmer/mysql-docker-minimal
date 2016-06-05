# Using MySQL with reduced images

The images created by this software aim at deploying a MySQL server from several versions using a combination of two containers.

There are several images **datacharmer/mysql-minimal** with version 5.0, 5.1, 5.5, 5.6, and 5.7.
Each image contains the latest tarball (or a very recent one) for the corresponding version.

As of its first release (June 2016) we have:

* 5.0.96
* 5.1.72
* 5.5.50
* 5.6.31
* 5.7.13

The reduced tarballs are a cherrypick of tarballs distributed by MySQL, with only the files strictly needed to run a server, and the debug information stripped out. (See [distro-resize](https://github.com/datacharmer/mysql-docker-sandbox/tree/master/distro-resize) for more info.)

These images are deployed with a lightweight carrier, i.e. using BusyBox as the operating system. It is not supposed to run in that image (too many libraries are missing) but it allows you to run MySQL in the flavor of your choice without wasting too much space.

To deploy an image, you need two steps.

With the first, you deploy the tarball **as a volume**

    docker create --name my_bin -v /opt/mysql  datacharmer/mysql-minimal:5.7

The path `/opt/mysql` contains the reduced tarball. It is deployed as a public volume, and the container is not running.

The second step is using the linux distribution of your choice. You may use any Linux distro, but then you'd have to install the server yourself. Instead, you use one of the following:

* `datacharmer/my-ubuntu`
* `datacharmer/my-debian`
* `datacharmer/my-centos`

Each one of these images has initialization code that can install a server from something found on /opt/mysql. For this to happen, you need to use the colume that was created in the previous step.

    docker run -ti --volumes-from my_bin --name mybox datacharmer/my-ubuntu bash



