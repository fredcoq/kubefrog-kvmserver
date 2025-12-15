### Setup for on-prem vm with raw devicxe block attached

After raw device blocked are attached to the vm they loose there device class and are by default tagged with hdd class.
Therefore to keep the distinction available and create specialized storage class it is required to manually set device class per osd.

If not alreday running, create a ceph toolbox pod and execute a shell in it.

Perform the following operation :

- list all the class available among the OSD's :
```
ceph osd crush class ls 
```
- to check which osd belongs to a class
``` 
ceph osd crush class ls-osd ssd
```
- to rename an OSD class, first you need to delete it before setting the new name :
```
ceph osd crush set-device-class <class> <osd-name>
ceph osd crush rm-device-class <osd-name>
```

