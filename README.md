# proactive-scheduler-dockerfile
Docker container with ProActive Scheduler in standard configuration.

## Arguments to ProActive Scheduler
Arguments given to the container a directly passed to the ProActive Scheduler. Find more details on the
ProActive documentation: http://doc.activeeon.com/

## How to start the ProActive Scheduler
The Scheduler runs by default with zero nodes (it is configured in the start script with -ln 0).

The Scheduler opens a few ports like the web interface and the Resource Manager. Furthermore it promotes
itself on the bound network interface. As a matter of fact the Scheduler container needs to run
with access to the host network interface, that is done by the Docker run option --net=host.

We want to bind the Scheduler to a specific network interface especially if the computer
has more than one. Otherwise the Scheduler will choose an interface itself. 
One can specify the interface to bind to with the -Dproactive.net.netmask= option.
Example:
```
-Dproactive.net.netmask=46.101.209.33/18 // The network interface's IP address with its netmask in CIDR notation.
```
Example Docker command:
```
docker run -d --name=pa-scheduler --net=host tobwiens/proactive-scheduler:latest -Dproactive.net.netmask=46.101.209.33/18
```
## Check if the Scheduler is started correctly
Check if the Scheduler is started correctly with the following Docker command:
```
docker logs pa-scheduler
```


## Troubleshooting 
In order to troubleshoot, find the Scheduler logs inside the container in the directory: /data/scheduling/logs.
You can read the logs directly with the following command:
```
docker exec -ti pa-scheduler less /data/scheduling/logs/Scheduler.log
```