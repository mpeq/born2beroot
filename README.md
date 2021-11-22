# **born2beroot**

This is my second project at 42. Create a virtual machine following specific requirements.

## **INTRODUCTION**

Under the introduction section you can read the evaluation script that was followed for my project to be reviewed, it basically encapsules all that I learnt while creating my virtual machine.

To sum up: I set up a virtual machine with a Debian OS using Virtual Box. I also installed and implemented some packages like: ufw (firewall), ssh, sudo, and libpam-pwquality.

Besides this, I made some changes in a few files to increase the security in the password `/etc/login.defs` & `/etc/pam.d/common-password` and in sudo's file `sudoers` via `visudo`command

Also explored what logical volumes are, created new users and groups (assigned these users to different groups) and used cron and wall in the execution of my script `monitoring.sh` which you can find in this repo.

## **EVALUATION SCRIPT**

### GENERAL INSTRUCTIONS

- Ensure that the "signature.txt" file is present at the root of the cloned repository → to get this file use command: `shasum born2beroot.vdi > signature.txt`
- Check that the signature contained in "signature.txt" is identical to that of the ".vdi" file of the virtual machine to be evaluated. If necessary, ask the student being evaluated where their ".vdi" file is located.
- As a precaution, you can duplicate the initial virtual machine in order to keep a copy.
- Start the virtual machine to be evaluated.

### MANDATORY PART

The project consists of creating and configuring a virtual machine following strict rules. The student being evaluated will have to help you during the defense. Make sure that all of the following points are observed.

### PROJECT OVERVIEW

The student being evaluated should explain to you simply:

- How a virtual machine works.
- Their choice of operating system (Debian).
- The basic differences between CentOS and Debian.
- The purpose of virtual machines.
- If the evaluated student chose Debian: the difference between aptitude and apt, and what APPArmor is.

During the defense, a script must display information all every 10 minutes. Its operation will be checked in detail later.

### SIMPLE SETUP

Ensure that the machine does not have a graphical environment at launch. A password will be requested before attempting to connect to this machine (ecryption password). Finally, connect with a user with the help of the student being evaluated. This user must not be root. Pay attention to the password chosen, it must follow the rules imposed in the subject.

- Check that the UFW service is started → `sudo ufw status verbose`
- Check that the SSH service is started → `sudo service ssh status`
- Check that the chosen operating system is Debian → `uname- a`

### USER

The subject requests that a user with the login of the student being evaluated is present on the virtual machine.

- Check that it has been added and that it belongs to the "sudo" and "user42" groups → `groups username`

Make sure the rules imposed in the subject concerning the password policy have been put in place by following the following steps:

- First, create a new user → `sudo adduser username`. Assign it a password of your choice, respecting the subject rules.

The student being evaluated must now explain to you how they were able to set up the rules requested in the subject on their virtual machine. Normally there should be one or two modified files:

You should find these implementations in: `/etc/login.defs`

```bash
PASS_MAX_DAYS    30
PASS_MIN_DAYS    2
PASS_WARN_AGE    7
```

You should find these implementations in: `/etc/pam.d/common-password`

```bash
minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username enforce_for_root difok=7
```

- Now that you have a new user, ask the student being evaluated to create a group named "evaluating" in front of you → `sudo addgroup evaluating` and assign it to this user → `sudo adduser username evaluating`
- Check that this user belongs to the "evaluating" group → `groups username`
- Finally, ask the student being evaluated to explain the advantages of this password policy.

### HOSTNAME AND PARTITIONS

- Check that the hostname of the machine is correctly formatted as follows: login42 (login of the student being evaluated) → `hostname`
- Modify this hostname by replacing the login with yours → `sudo vim /etc/hostname`, then restart the machine → `sudo reboot`
- Ask the student being evaluated how to view the partitions for this virtual machine → `lsblk`
- Compare the output with the example given in the subject.

The student being evaluated should give you a brief explanation of how LVM works and what it is all about.

### SUDO

- Check that the "sudo" program is properly installed on the virtual machine → `whereis sudo` or `sudo --version`
- The student being evaluated should now show assigning your new user to the "sudo" group → `sudo adduser username sudo`
- The subject imposes strict rules for sudo. The student being evaluated must first explain the value and operation of sudo using examples of their choice. In a second step, it must show you the implementation of the rules imposed by the subject.

You should find these implementations in the sudoers file:

```bash
Defaults    passwd_tries=3
Defaults    badpass_message="Incorrect password"
Defaults    logfile="/var/log/sudo/sudo.log"
Defaults    log_input,log_output
Defaults    iolog_dir="/var/log/sudo"
Defaults    requiretty
Defaults    secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```

- Verify that the "/var/log/sudo/" folder exists and has at least one file → `sudo.log`
- Check the contents of the files in this folder → you need to login as root to do so, `su -`, then go to that directory and `cat sudo.log`
- You should see a history of the commands used with sudo.
- Finally, try to run a command via sudo. See if the file(s) in the "/var/log/sudo/" folder have been updated.

### UFW

- Check that the "UFW" program is properly installed on the virtual machine → `whereis ufw` or `ufw --version`
- Check that it is working properly → `sudo ufw status verbose`
- The student being evaluated should explain to you basically what UFW is and the value of using it.
- List the active rules in UFW. A rule must exist for port 4242.
- Add a new rule to open port 8080 → `sudo ufw allow 8080`. Check that this one has been added by listing the active rules → `sudo ufw status verbose`
- Finally, delete this new rule → `sudo ufw status numbered`, `sudo ufw delete 4`, `sudo ufw delete 2`

### SSH

- Check that the SSH service is properly installed on the virtual machine → `whereis ssh`
- Check that it is working properly → `sudo service ssh status`
- The student being evaluated must be able to explain to you basically what SSH is and the value of using it.
- Verify that the SSH service only uses port 4242.
- The student being evaluated should help you use SSH in order to log in with the newly created user. To do this, you can use a key or a simple password. It will depend on the student being evaluated → from the computer's terminal use the command: `ssh username@localhost p- 4242`

Of course, you have to make sure that you cannot use SSH with the "root" user as stated in the subject.

### SCRIPT MONITORING

The student being evaluated should explain to you simply:

- How their script works by showing you the code → `sudo vim /usr/local/bin/monitoring.sh`
    
    The script has to show:
    

```bash
#The architecture of your operating system and kernel version.
#The number of physical cores. CPU
#The number of virtual cores. Virtual CPU
#The RAM currently available on your server and its percentage of use.
#The memory currently available on your server and its use as a percentage.
#The current percentage of use of your cores.
#The date and time of the last reboot.
#Whether LVM is active or not.
#The number of active connections.
#The number of users of the server.
#The IPv4 address of your server and its MAC (Media Access Control)
#The number of commands executed with sudo.
```

- What "cron" is → `sudo crontab -e`
- How the student being evaluated set up their script so that it runs every 10 minutes (this rule should be implemented in crontab → `*/10 * * * * /usr/local/bin/monitoring.sh`)
- Once the correct functioning of the script has been verified, the student being evaluated should ensure that this script runs every minute. You can run whatever you want to make sure the script runs with dynamic values correctly.
- Finally, the student being evaluated should make the script stop running when the server has started up, but without modifying the script itself → command `/etc/init.d/cron stop`. To check this point, you will have to restart the server one last time. At startup, it will be necessary to check that the script still exists in the same place, that its rights have remained unchanged, and that it has not been modified.
