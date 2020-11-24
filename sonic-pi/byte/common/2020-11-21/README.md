# Performance for COMMON 21.NOV.2020

## What's in this directory
The files here are the source code for my 1 hour live coding performance during the Currents.fm COMMON 21.NOV.2020 event, as part of the Byte live coding collective.
This includes the code that was manipulated in each buffer inside Sonic Pi at the time, as well as code in several supporting files used but not modified during the performance.
The files each named 'buffer X.rb' contain the manipulated code in its end-of-performance state.

Some extra comments have been added after the fact. These hopefully explain the most significant parts of the code in relation to custom functions and behaviour specific to this performance.
While the code and inserted comments are hopefully sufficient, if you still have questions feel free to contact me as seen further down. 

## Minimum Sonic Pi version required
[v3.2.1](https://github.com/sonic-pi-net/sonic-pi/releases/tag/v3.2.1) (for a correctly functioning `:ping_pong` fx).

## How to use this code in Sonic Pi
If you wish to test this code inside Sonic Pi yourself, you could follow the below steps:
- Ensure that the utility functions are in memory and ready to use. There are several ways to do this, but the quickest is to copy the contents of the file 'utility functions.rb' into a spare buffer in Sonic Pi and hit `Run`. Alternatively, you could choose to do it in a way that does not use up a spare buffer - by using the Sonic Pi start-up file `init.rb` in your `.sonic-pi` directory and using `run_file` in it for example.
- Copy the contents of files 'buffer 0.rb', 'buffer 1.rb', 'buffer 2.rb', 'buffer 3.rb', 'buffer 4.rb' and 'buffer 5.rb' into the corresponding buffers in Sonic Pi. Everything you need to reproduce the same kind of sounds as in the original performance will now be ready. (Keeping in mind again that the code is of course in its _end-of-performance_ state).
- For the sake of completeness, the snippets used in the performance are also available. If you wish to use these, place the snippets folder in a location of your choosing, and in a Sonic Pi buffer (or using the `init.rb` file again) load the snippets into memory by running code similar to the following: `load_snippets('path/to/your/snippets/folder')`. The snippets will then be available when typing in Sonic Pi.

## Corresponding audio/visual media
The original video recording of this performance can be found on YouTube at [https://www.youtube.com/watch?v=PImAqLc3TN8](https://www.youtube.com/watch?v=PImAqLc3TN8).

## Contacting me
If you have questions or comments about this source code, feel free to find me on the [Sonic Pi community forum](https://in-thread.sonic-pi.net) (@ethancrawford), or create an issue on [my live coding GitHub repository](https://github.com/ethancrawford/live-coding).
