## -*- texinfo -*-
##
## @deftypefn {Function File} {} sendvec2serial(@var{s_vec}, @var{s_port}, @var{s_baud})
## @deftypefnx {Function File} {} sendvec2serial(@var{s_vec}, @var{s_port}, @var{s_baud}, @var{s_time}, @var{s_gui})
##
## Send a given @var{s_vec} of numbers to a specified serial port @var{s_port}. 
## It sends number after number with a given time gap. 
##
## You need to specify the vector @var{s_vec}, the port name @var{s_port} and the 
## baud rate @var{s_baud} at least. Optional the time gap @var{s_time} 
## (default: 1 second) can be committed and - if you want to see a visualisation 
## - a GUI waitbar @var{s_gui} while sending (default: true). With the waitbar you 
## are able to abort the transmission otherwise you have to wait untill the 
## sending is completed and you do not see any visualisation just a blinking cursor.
## 
## DEPENDENCY:
##
## The package "instrument-control" is needed to run "sendvec2serial" 
## (refer http://octave.sourceforge.net/packages.php). On Windows you may refer
## http://blog.hani-ibrahim.de/en/ocatave-packages-windows-install.html also.
##
## @group
## @verbatim 
##INPUT:
##
##   s_vec          Octave Vector of numbers (row or column vectors are 
##                  valid)
##   s_port         Name of the serial Port, e.g. COM1, /dec/ttyUSB0, etc
##   s_baud         Baud rate, transmission speed, e.g. 2400, 9600, etc.
##   s_time (OPT)   Time gap between sending numbers. 1 means it waits 
##                  1 second before it sends the next number. (default: 1)
##   s_gui  (OPT)   Displays a GUI waitbar for visualisation of the 
##                  transmission and to abort the transmission if disired 
##                  (default: True).
## 
##OUTPUT
##
##   status         Return a status number:
##                  0: Transmission completed (everything went OK)
##                  1: Missing arguments (s_vec, s_port, s_baud at least).
##                  2: Missing installed package "instrument-control".
##                  3: Portname or baud rate are not valid.
##                  4: Transmission was aborted
##
## @end verbatim
## @end group
##
## EXAMPLES
## @example
## @group
##
## vector1 = [ 1 2.3 3.5 4.4 5.0 6.5 7 8.7 9.8 10];
##
## S = sendvec2serial(vector1, 'COM1', 9600);
##
##    Send the vector "vector1" to the port "COM1" with 9600 baud
##    with a time gap of one second (default) and with a displayed
##    waitbar (default). Variable "S" stores the status number.
##
##
## S  = sendvec2serial(vector1, '/dev/ttyUSB1', 11500, 0.5, false);
##
##    Send the vector "vector1" to the port "/dev/ttyUSB1" with 
##    11500 baud with a time gap of 0.5 seconds and without a 
##    displayed waitbar. Variable "S" stores the status number.
##
## @end group
## @end example 
##
## Author: Hani Andreas Ibrahim <hani.ibrahim@gmx.de>
##
## License: GPL 3.0 <https://gnu.org/licenses/gpl-3.0.en.html>
## @end deftypefn

function [status] = sendvec2serial(s_vec, s_port, s_baud, s_time, s_gui)
  
  % Check for committed arguments and setup defaults for optional arguments
  if (~exist('s_vec','var') || ~exist('s_port','var') || ~exist('s_baud','var'))
    status = 1; % vector or/and portname and/or baud are missing
  endif
  if (~exist('s_time','var')); s_time = 1; endif % 1 sec. waittime per default
  if (~exist('s_gui','var')); s_gui='True'; endif % Use GUI waitbar per default    
  
  s_len = length(s_vec); % count numbers in file
  
  % Check for package "instrument-control"
  try
    pkg load instrument-control
  catch
    status = 2; % Package "instrument-control" not installed
    return;
  end_try_catch

try
  s1 = serial(s_port, s_baud); % Init port
catch
  status = 3; % Portname or baud rate are not valid
  return;
end_try_catch

srl_flush(s1); % Flush port

if s_gui % Display GUI waitbar
  % Init waitbar
  h = waitbar(0,'','Name','Sending data ...');
  % Send numbers
  for i=1:s_len
    if ishandle(h) % Check whether process is canceled in the interim
      srl_fwrite(s1, [num2str(s_vec(i)) "\n"]); % Write number to port
      waitbar(i/s_len,h,['... via ' ... 
        num2str(s_baud) '-8-1 to port ' ...
        s_port '    [' ...
        num2str(floor(i*100/s_len)) '%]']);
        pause(s_time) % Wait for n seconds
    else
      status = 4; %ERROR Transmission aborted
      return;
    endif
  endfor
  try
    close(h); % Close waitbar
  end
else % No waitbar displayed, only cursor blinking, no abortion
  % Send numbers
  for i=1:s_len
    srl_fwrite(s1, [num2str(s_vec(i)) "\n"]); % Write number to port
    pause(s_time) % Wait for n seconds
  endfor
endif

srl_close(s1); % Close port
status = 0;
return;