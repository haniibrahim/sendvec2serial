#!/usr/bin/octave -qf
% SendFile2Serial writes a number per second to an serial port from a given file
% 
% SenFile2Serial is a demonstartion script for the function file "sendvec2serial"

clear;
clc;

% Log to stdout
disp('SendFile2Serial script started');

% Helper variable
s_break = false;

% Choose file
[f,p] = uigetfile('', 'Choose file to send');
s_file = strcat(p, f); % concatenate path and file string

% Process file selection
if (f == 0)
  errordlg('ERROR: File selection aborted, script terminated','SendFile2Serial');
  error('File selection aborted, script terminated');
  break;
endif
try
  s_vector = load(s_file); % Load file content in vector
catch
  errordlg('ERROR: Wrong file format','SendFile2Serial');
  error('Wrong file format');
  break;
end_try_catch

% Port configuration
dlg_prompt   = {'Serial port (e.g. COM1 or /dev/pts/3)', 'Baud', ... 
                'Time gap [s] (e.g. 1 = send one number per second)'};
dlg_title    = 'Send numbers from a file to serial port';
dlg_lines    = 1;
dlg_defaults = {'/dev/pts/3', '9600', '1'};
answ = inputdlg(dlg_prompt, dlg_title, dlg_lines, dlg_defaults);

% Inputprocessing
if isempty(answ)
  warndlg('Script terminated','SendSerialFile');
  error('Script terminated');
  break;
endif
s_port = answ{1};
s_baud = str2num(answ{2});
s_time = str2num(answ{3});

% Apply the function file "sendvec2serial()"
st = sendvec2serial(s_vector, s_port, s_baud, s_time, true);

% Processing status "st" numbers
switch(st)
  case (1)
    error('Missing arguments');
    print_usage('sendvec2serial')
    break;
  case (2)
    error('Missing installed package "instrument-control');
    break;
  case (3)
    errordlg('Portname or baud rate are not valid','SendFile2Serial');
    error('Portname or baud rate are not valid'); 
    break;
  case (4)
    errordlg('ERROR Transmission aborted','SendFile2Serial');
    error('Transmission aborted');
    break;
  otherwise
    msgbox('Data sent', 'SendFile2Serial');
    disp('Data sent');
endswitch
    
