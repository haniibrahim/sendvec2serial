# sendvec2serial.m

Octave function file

## Purpose

**Send a given vector of numbers to a specified serial port. It sends number after number with a time gap.**

You need to specify a vector S_VEC, the port name S_PORT and the baud rate S_BAUD at least. Optional the time gap S_TIME (default: 1 second) can be committed and - if you want to see a visualisation - a GUI waitbar S_GUI while sending (default: true). With the waitbar you are able to abort the transmission otherwise you have to wait untill the sending is completed and you do not see any visualisation just a blinking cursor.

The other serial parameters are: 8 databits, 1 stopbit and no parity. In this version you cannot change these parameters by committing arguments (but feel free to extend this function).

## Application

You can use this function to build scripts which simulate a micro controller sending data from a sensor to test your own applications.
 
## Dependency

The package **"instrument-control"** is needed to run "sendvec2serial" (refer http://octave.sourceforge.net/packages.php). 

On **GNU/Linux** or other Unices type `pkg install -forge instrument-control` in Octave if the package is not provided by the package manager of your GNU/Linux distribution. Take care that you have internet access. You may need to have a C/C++ compiler and "make" installed. On Debian/Ubuntu systems type `apt-get install build-essential`.

On **Microsoft Windows** you may refer http://blog.hani-ibrahim.de/en/ocatave-packages-windows-install.html for details.

**Mac OS X** users can use [MacPorts](http://www.macports.org/) or [HomeBrew](http://brew.sh/). In general you have one of these package manager already installed for getting Octave itself.

## Usage

```
USAGE

   status = sendvec2serial(s_vec, s_port, s_baud)
   status = sendvec2serial(s_vec, s_port, s_baud, s_time, s_gui)

INPUT:

   s_vec          Octave Vector of numbers (row or column vectors are 
                  valid)
   s_port         Name of the serial Port, e.g. COM1, /dec/ttyUSB0, etc
   s_baud         Baud rate, transmission speed, e.g. 2400, 9600, etc.
   s_time (OPT)   Time gap between sending numbers. 1 means it waits 
                  1 second before it sends the next number. (default: 1)
   s_gui  (OPT)   Displays a GUI waitbar for visualisation of the 
                  transmission and to abort the transmission if disired 
                  (default: True).
 
OUTPUT

   status         Return a status number:
                  0: Transmission completed (everything went OK)
                  1: Missing arguments (s_vec, s_port, s_baud at least).
                  2: Missing installed package "instrument-control".
                  3: Portname or baud rate are not valid.
                  4: Transmission was aborted
```

## Sample Script

You find a demonstration script "SendFile2Serial.m" with GUI in this distribution. This script loads a file ...

![uigetfile()](http://blog.hani-ibrahim.de/wp-content/uploads/sendvec2serial_1.png)

... with numbers, as:

```
1.9
2.34
2
1.87
2.07
1.98
...
```

... and specify the serial parameters and the time gap ...

![inputdlg()](http://blog.hani-ibrahim.de/wp-content/uploads/sendvec2serial_2.png)

... and observe the processing, abort if neccessary:

![waitbar()](http://blog.hani-ibrahim.de/wp-content/uploads/sendvec2serial_3.png "GUI waitbar")

*The waitbar above is ++optional++ provided by the function "sendvec2serial" and not by the sample script -> argument S_GUI* 

All screenshots from Linux Mint Cinnamon. But the script works on Windows and Mac, too.

## License
Copyright (C) 2016  Hani A. Ibrahim, GPL 3.0

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.