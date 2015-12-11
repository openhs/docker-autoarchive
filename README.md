# docker-autoarchive

Docker image for AutoArchive - a simple backup utility



## Usage

Create a simple backup with:

    $ docker run --rm -v /path/to/data:/opt/aa/mounts -v /var/backups:/opt/aa/backup openhs/autoarchive backup
    
Content of the host directory ___/path/to/data___ will be archived as
___/var/backups/backup.tar.gz___ on the host.

For incremental backups the container needs to be kept because it will be re-run for
subsequent increments.  To create level 0 increment execute:

    $ docker run --name data_backup -v /path/to/data:/opt/aa/mounts \
        -v /opt/backups:/opt/aa/backup openhs/autoarchive backup-incremental
    
Subsequent increments can be created with:

    $ docker start -i data_backup



## Advanced Usage

### Custom archive configurations

For more fine grained control it is possible to specify custom archive configurations.
To do so pass a host directory with your custom archive specification files as a volume
mounted to ___/opt/aa/archive_specs___.

Let's have two archive specification files -- one intended to backup ___/home___ and
the other ___/etc___ directory on the host:

    $ ls /var/archive_configs
    home.aa  etc.aa
    $ cat home.aa
    [Content]
    path = /opt/aa/mounts
    include-files = home
    exclude-files =
    $ cat etc.aa
    [Content]
    path = /opt/aa/mounts
    include-files = etc
    exclude-files =

Hosts directories ___/home___ and ___/etc___ needs to be mounted into the container at
the place where it is expected by AutoArchive (which is determined by `path` and
`include-files` options above).

    $ docker run --rm \
        -v /var/archive_configs:/opt/aa/archive_specs \
        -v /home:/opt/data/mounts/home \
        -v /etc:/opt/data/mounts/etc \
        -v /opt/backups:/opt/aa/backup \
        openhs/autoarchive --all

Option `--all` causes to create all configured backups which in our case are
__home__ and __etc__.


### Interaction with existing containers

To interact with the existing container use `--volumes-from` Docker option.  For
example to show information about the incremental archive from the example above run:

    $ docker run --rm --volumes-from data_backup openhs/autoarchive --list
    
    
### AutoArchive help

To see help screen run:
    
    docker run --rm openhs/autoarchive --help


## Detailed description

AutoArchive is pre-configured with two archives: __backup__ and __backup-incremental__.
Both of them backup everything under ___/opt/aa/mounts___ and the resulting
backup file is put into ___/opt/aa/backup___ within the container.  Backup
creation therefore requires specifying desired host directories as volumes mounted to
the paths above.

The incremental backup creates 9 increments before restarting back to increment level 1.
When restarting, all the existing increments are renamed ("aa" is inserted to the names).


## Reference

+ [AutoArchive documentation](http://autoarchive.sourceforge.net/doc/user/index.html)
