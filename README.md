# Processing Rubik's Cube
A simple graphical Rubik's Cube toy written in Processing.

If you're a mathematician or set theory enthusiast... I'm so sorry.

## Controls
The whole cube can be clicked and dragged with the mouse to change the view. However changing the view does not change the orientation of the cube with respect to the keyboard controls - i.e. the green face is always mapped to "Front" and the yellow face is always mapped to "Upper".

All cube rotations are controlled by the keyboard, maybe eventually I will add support for clicking faces to rotate them.
Keys are bound to the standard cubing face turn notation, with lowercase corresponding to clockwise and a capital (shift+letter) corresponding to counter-clockwise:
* U - Upper Face
* F - Front Face
* R - Right Face
* L - Left Face
* B - Back Face
* D - "Down" or Bottom Face


For example, the T permutation normally reads, in standard notation: RUR'U'R'FR2U'R'U'RUR'F'

To perform the T permutation in this simulator, you would type out: "ruRURfrrURUruRF"
