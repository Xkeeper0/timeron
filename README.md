# timeron

big ol' timer that scales to whatever size you happen to resize it to. good if you have an awkward need for some huge digits.

counts down from whatever number you punch in to zero, then back up to 99:59 if you leave it alone long enough.

colors change between modes to help indicate current state even from far away!
* green: input. 0-9 adds time (think microwaves), backspace clears the last digit
* gray: ready to start
* blue: counting down
* red: countdown expired, counting up now

helpfully beeps when timer starts and when timer reaches 0:00



written in lua using [love2d](https://love2d.org), last tested in version 11.1. may not work in newer versions.


inputting time
![screenshot of inputting time into timer](http://i.imgur.com/4M1bk6f.png)

counting down
![screenshot of time counting down. somehow.](http://i.imgur.com/x3E9yHu.png)

time has expired and is now counting up
![screenshot of timer counting up after time expires](http://i.imgur.com/Ialigpo.png)
