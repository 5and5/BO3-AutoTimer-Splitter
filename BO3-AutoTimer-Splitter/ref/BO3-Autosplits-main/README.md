# BO3-Autosplits
A collection of autosplitters for round based speedrunning, as well as a basic timer for all purposes

# IMPORTANT
This only works for solo. The round variable is different if you're not the host and the variable doesn't always update in time so the timer will be late. For this reason, I'm not including it at all for co-op because it's not accurate.

The basic autosplitter won't do any splits for you. It's there to start the timer and pause, that's it.

The basic game time autosplitter will connect to the game's timer regardless of when you start livesplit. 
### IMPORTANT: The in game timer takes a long time to stop when you pause, so if you pause a lot, the timer won't accurately reflect how long you've actually been playing, but this is the exact value that the game stores.

## HOW TO USE
Download the corresponding timer for what you want to do

To remove pause times:
</br>Right-Click Livesplit -> Compare Against -> Game Time

To load the splits/layout:
</br>Right-Click Livesplit -> Open Splits -> From File... -> Navigate to and select the corresponding .lss file

Right-Clck Livesplit -> Open Layout -> From File... -> Navigate to and select the corresponding .lsl file

Right-Clck Livesplit -> Edit Layout -> Double click Scriptable Auto Scripter -> Brosw -> Navigate to and select the corresponding .asl file

## ROUND SPLITS
The round splits are as follows. The only difference between the files is where the rounds stop, the intervals between the rounds is the same

5, 10, 15, 20, 25, 30, 50, 70, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 255

## HOW IT WORKS
The timer will start when round 1 begins, which is roughly when you gain control of your character

The timer will reset if you restart the map, or if you leave the game and keep it running long enough to get back to the main menu

The timer will pause if you pause

The timer will split for the corresponding round of the split segments
