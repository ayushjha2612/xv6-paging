
# xv6-paging and other system calls

This project uses xv6 (learning operaying system by MIT) and adds some custom system calls and demand paging.

## Description

The xv6 version used is available [here](https://github.com/mit-pdos/xv6-public). To this xv6 following features were added:
*  **Printing system calls** : Prints each sysem call in the xv6 kernel as xv6 boots up.
*  **system call- mydate** : Reports the current system time
*  **system call- mypgtPrint** : Prints the page table entries
*  **system call- setPriority** : Changes the priority of the current process
*  **Priority-based scheduling** : Schedulles all processes in xv6 based on their priority.
*  **Demand-Paging** : Introduced demand paging for dynamic memory allocation.

For further details and better understanding on each feature refer the reports. 

## Getting Started

### Dependencies

* xv6 only works on linux/unix based systems, thus this project would not work on windows.
* Install the following library on your Ubuntu system:
```
sudo apt-get install qemu qemu-system g++-multilib git-all grub2 grub-pc-bin libsdl-console-dev
```

### Installing

* Clone this repository by 
```
git clone https://github.com/ayushjha2612/xv6-paging xv6-modified
```

### Executing program

* To run the program open directory where you have cloned the repository. Then enter on terminal: 
```
cd xv6
make qemu-nox
```
* To test out each feature enter the following commands on the xv6 shell for above features:
```  
myPrioritySched
mydate
mypgtPrint
mydemandPage
```


