<!--<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html> <head>
<title>dish</title>
</head>

<body bgcolor="#ffffff">-->
<h1>dish --- distributed shell</h1>
<img src="wheel.gif">
current version: 1.22
<!--<ul>
<li><a href="dish_1.20-1_i386.deb">dish_1.20-1_i386.deb</a>
<li><a href="dish-1.20-1_i386.rpm">dish-1.20-1_i386.rpm</a>
<li><a href="dish-1.22.tar.gz">dish-1.22.tar.gz</a>
</ul>-->
<hr>
Dish is a distributed shell. It is designed to replace 'sh -c' command
used in GNU make. It enables us to execute
many procedures at a time over network-linked heterogeneous
workstation cluster.<p>

Dish works just like 'sh -c' command, <i>ie</i> it gets command line 
arguments and executes them as Bourne shell script. Internally
the arguments are given to remote shell command, executed on remote
workstation, and the status of the remote execution is returned.
<p>

Dish is useful for the jobs in which hundreds of independent tasks must be
processed on the distributed hosts, e.g. making animations, converting
many sound files, compiling huge software like unix kernel, etc.l<p>

Remote host on which the commands are executed is chosen from 
given list. If you intend to make binary files which depend on the
system architecture, all the remote host in the list must be of the
same architecture.<p>

Dish executes command on the remote directory where is the same with
local directory. It is required that both the remote and local machine
shares the directories and the tree topology of the directories on
both machine are the same. <p>

<h2>command usage</h2>
<pre>
usage:  dish [options] foo [x] [bar [y] ... ] -c cmds
Dish executes the specified command on one of the remote hosts.
It distributes at most x jobs to the remote host foo and y jobs to bar.
Default number of jobs is 1 if it is omitted.

Options
    -h, --help         Show this message.
    -i, --interactive  By default, dish ignores any input from stdin.
                       With this option, dish reads from stdin.
    -v, --verbose      Display debug messages
    -r, --refresh      Remove lock files and go.
    -s, --ssh          Use ssh instead of ersh.
    -g, --group GROUP  Get host list from $(HOME)/.dish_group/GROUP file
                       instead of command line arguments.
    -p, --pwd PATH     Specify current directory explicitly.
                       dish usually gets current path from PWD environment 
                       variable. However, some shells do not set PWD variable
                       and dish tries to get it by pwd command, which only
                       returns the absolute     path. Representation of current 
                       absolute path sometimes differs between local and 
                       remote host when the current path involves symbolic 
                       link. 
    -c     Terminator symbol of host list.
    cmds   Bourne shell commands to be executed.
</pre>
<h2>Replacement of standard shell in Makefile</h2>
GNU make usually executes only one rule at a time. While specifying -j
option enables the parallel execution.
We utilize this facility of GNU make for cluster-wide command
execution.
With -j option, GNU make analyses the dependencies of the rules and
executes independent rules by standard shells in parallel manner. Each 
shell treats short "thread" of rules in the Makefile and return result
status code to GNU make.<p>

We replace the standard shell with dish, which performs just like
"sh -c" command.
When "SHELL" variable in the Makefile is defined, each
rule-descripting line is executed by SHELL instead of "/bin/sh -c".
Dish exports each threads to one of remote hosts and
report the result status to GNU make.<p>

Max number of parallel jobs (which is specified with -j option) should 
be greater than sum of x (specified at the argument of dish). 
Dish controls the number of jobs by itself when it is invoked multiply.<p>

To distribute "make" processes onto multiple hosts, type
<pre>
make -j 10 SHELL="dish host1 2 host2 host3 4"
</pre>
Make executes 10 independent rules at a time. 2 of them are exported
to host1, 1 to host2, 4 to host3, and the rest 3 rules are suspended.<p>

Dish works on the host workstation where GNU make command is
invoked. It is unsecessary to install anything on the remote
workstations.<p>

(v1.21)When -g option is given, dish looks up host list from ~/.dish_group/GROUPFILE (GROUPFILE is the argument given with -g option) instead of command line arguments. It is useful when you run dish on large-scale cluster.

For example, put the following text to the file ~/.dish_group/clients,
<pre>
c001 2
c002 2
c003 2
</pre>
and run "make" using dish with -g option.
<pre>
make -j 6 all SHELL="dish -g clients"
</pre>

<h2>Note</h2>
<p>
Standard remote shell command ('rsh') does not return the status of
remote execution. In dish, ersh is used in place of standard rsh. Ersh 
is written by Maarten Litmaath in 1994. With -s option, dish also uses ssh(secure shell).
In this case, ssh server must be installed in the remote host.</p>

<p>This limitation will be avoided by using ssh in version 1.22.</p>

<p>On linux, make is GNU make. While in general make is not GNU
make. Please consult administrator whether your machine has GNU make
command.</p>

Dish creates a work directory named .dish in your home directory for exclusive process control.<p>

Dish behaves as "on" command when it is aliased.
<h2>Bugs</h2>
Dish sometimes fails when the command line includes many quotation
marks. It will be limitation of shell script and I could not avoid
this. Rewrinting dish by C-language will solve this problem.
<h2>Analogs</h2>
<a href="http://www3.informatik.tu-muenchen.de/~zimmerms/ppmake/">PVM Parallel Make (ppmake)</a>
<h2>Change Log</h2>
<dl>
<dt>v1.22 Feb.6, 2013
<dd>Moved to GitHub. 
<dt>v1.21 Feb.19, 2003
<dd>-g|--group option is added.
</dl>
<h2>Acknowledgment</h2>
I'd like to thank to the following people who gave me a lot of valuable opinions, patches, and contributions.
<ul>
<li>Seisei Yamaguchi
</ul>
<hr>
Any comments and questions to <a
href="mailto:vitroid@gmail.com">vitroid@gmail.com</a>.
<p>

<!--</body> </html>-->
