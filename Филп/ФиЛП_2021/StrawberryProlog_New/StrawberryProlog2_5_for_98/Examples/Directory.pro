% ########################
% Warning! This program will not work under the Light Edition

?-
  write(get_current_directory()), nl,
  set_current_directory("c:\\"),
  write(get_current_directory()), nl,
  set_current_directory(_),
  write(get_current_directory()), nl.
