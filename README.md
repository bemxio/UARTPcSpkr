# UARTPcSpkr
This project implements a [PC speaker](https://en.wikipedia.org/wiki/PC_speaker) interface for a [TempleOS](https://templeos.org) VM over the [serial port](https://en.wikipedia.org/wiki/Serial_port), using an [Arduino](https://www.arduino.cc/) and an external buzzer.

It consists of a replacement for [`/Kernel/KMisc.HC.Z`](https://github.com/cia-foundation/TempleOS/blob/archive/Kernel/KMisc.HC), which modifies `Snd` to initialize COM1 and then send the frequency value as a `U16` to the port, and an Arduino sketch that takes the value and uses `tone()` / `noTone()` to control the buzzer.

## Installation
Follow the steps below to set up both TempleOS and your Arduino. Note that some steps may differ, based on your specific board, virtualization software and host operating system. This guide assumes you're on Linux, running TempleOS through VMware Workstation 17.

1. Connect a buzzer to an Arduino board, with the positive leg connected to digital output pin 8 and the negative leg connected to GND.

2. Clone the repository with `git clone https://github.com/bemxio/UARTPcSpkr` or download the ZIP archive from GitHub and extract it to a location of your choice.

3. Upload the sketch to your Arduino using the [IDE](https://docs.arduino.cc/software/ide) or [CLI](https://docs.arduino.cc/arduino-cli):

    ```
    $ arduino-cli core install arduino:core
    $ arduino-cli compile --fqbn arduino:core:board
    $ arduino-cli upload --fqbn arduino:core:board -p /dev/ttyXXXX
    ```

    Replace `arduino:core:board` with the fully qualified board name of your Arduino (e.g. `arduino:avr:uno`) and `/dev/ttyXXXX` with the port your Arduino is connected to (e.g. `/dev/ttyUSB0`).

4. Copy the .HC files over to your TempleOS installation. The easiest way to do this for now is by creating a FAT32 virtual 4isk image inside VMware, mounting it and copying the files on your host OS, and then mounting the image in TempleOS.

    - In order to create a virtual hard disk compatible with TempleOS, open VMware Workstation and follow this route: `Edit virtual machine settings > Add... > Hard Disk > Next > IDE (Recommended) > Create a new virtual disk > Maximum disk size (in GB): [any] > Allocate all disk space now > Store virtual disk as a single file > Next > Finish > Save`.

    - Afterwards, run TempleOS, and proceed to mount, partition and format the disk using `DskPrt`. Go through the prompts, picking an unused drive letter, probing hardware, selecting the disk's I/O port base, and creating a logical partition that takes up the entire disk. Shut down the VM once the process is complete.

    - Set up a loopback device and mount the image with the `-flat.vmdk` ending to a mountpoint of your choice (replace `/path/to/image-flat.vmdk` and `/dev/loopXp1` with the path to the image and the loop device printed by `losetup` respectively):

        ```
        # losetup -fP --show /path/to/image-flat.vmdk
        # mount -o uid=$(id -u),gid=$(id -g) /dev/loopXp1 /mnt/vmdk
        ```

    - At last, copy the .HC files to the mounted disk image, unmount it and detach the loop device:

        ```
        $ cp *.HC /mnt/vmdk

        # umount /mnt/vmdk
        # losetup -d /dev/loopXp1
        ```

5. Open VMware, go to the virtual machine settings, add a new serial port and specify the serial port device as the output file. (`Edit virtual machine settings > Add... > Serial Port > Finish > Use output file: > /dev/ttyXXXX > Save`, replace `/dev/ttyXXXX` with the port your Arduino is connected to, e.g. `/dev/ttyUSB0`).

6. Launch TempleOS, mount the virtual disk, include the installer script and run it:

    ```
    MountIDEAuto; // should assign the disk to G, verify with DrvRep
    Drv('G');

    #include "Installer";
    Install;
    ```

    Proceed forward with the installation, mounting your boot drive (for whatever reason, you cannot continue without mounting a drive, even when it seems to be mounted already) and using default values. You'll need to reboot your VM for changes to take effect.

## Usage
Before launching the VM, initialize the serial port by running the following command in your host OS terminal (replace `/dev/ttyXXXX` with the port your Arduino is connected to, e.g. `/dev/ttyUSB0`):

```
# stty -F /dev/ttyXXXX cs8 115200 ignbrk -brkint -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
```

After starting up TempleOS, it should now send any PC speaker commands to the Arduino, which should play them through the buzzer. You can quickly test if it's working by using the `Beep` function.

## Configuration
There are a couple of defines in both source files that you can modify:
- [`UARTPcSpkr.ino`](UARTPcSpkr.ino):
    - `BUZZER_PIN`: Digital output pin the buzzer is connected to. Defaults to `8`.
    - `BAUD_RATE`: Baud rate for serial communication. Make sure it matches the one in `KMisc.HC` and the `stty` command. Defaults to `115200`.
- [`KMisc.HC`](KMisc.HC#L163-L165):
    - `COM_PORT`: Serial port address used for the interface. Defaults to `0x3F8`, (standard I/O port for COM1).
    - `BAUD_RATE`: Baud rate for serial communication. Make sure it matches the one in `UARTPcSpkr.ino` and the `stty` command. Defaults to `115200`.

## Removal
The [`Installer.HC`](Installer.HC) script also includes an `Uninstall` function that restores the original `KMisc.HC.Z` file from the `KMisc.BAK.Z` backup created during installation. To uninstall UARTPcSpkr, include the installer script and run the function:

```
#include "Installer";
Uninstall;
```

## Troubleshooting
In case you run into any problems, feel free to create a new issue [here](https://github.com/bemxio/UARTPcSpkr/issues). I'll try my best to help you out as soon as possible.

## License
This project is licensed under the MIT License - see the [`LICENSE`](LICENSE) file for details.

Contributions are welcome! If you want to contribute, whether it's an issue you've encountered or a pull request with new features, feel free to do so.