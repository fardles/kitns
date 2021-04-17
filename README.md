# kitns

> *KIT*s for *N*orn*S*

Pronounced, "kittens" -- a basic sample kit creator for norns. 

I made this as a simple utility and an exercise in coding. This is an utility that is meant to help with scripts like [gridstep](https://llllllll.co/t/gridstep-now-with-timber-ui/38559), [timber](https://llllllll.co/t/timber/21407), and [nisp](https://llllllll.co/t/nisp/27596), which give the option of loading a whole folder of samples. It's a little step forward in giving back to this wonderful community.

While I was playing with nisp, I was wondering how I could build a simple kit folder without going onto the computer. I wasn't aware of a script that did this yet (I could be wrong -- in which case please let me know) so I thought it would be a good challenge to try to build one.

I'm not a coder by any means, more like a code-scavenger. Credit must go to scripts like [mx.samples](https://llllllll.co/t/mx-samples/41400) (by @infinitedigits), [timber](https://llllllll.co/t/timber/21407) (by @markeats), and [nisp](https://llllllll.co/t/nisp/27596) (by @its_your_bedtime), from which I have culled much of the functionality of the script. Many thanks also to the wonderful developers who contributed to the excellent libraries on the norns, in particular,`fileselect` and `textentry`.

Apart from this being hopefully useful to others, I'd be interested in getting critique and pointers for my coding. I hope this doesn't crash anyone's norns either. 

## Requirements

- norns
- engine: timber

## Documentation

1. Navigate to `PARAMS` then `EDIT`
2. Select the option `+ Load Folder` and press K3. Navigate to the desired folder. In that folder, use E2 to highlight the first sample which you wish to load and press K3. **Note**: The samples are loaded from the selected sample and following, and any samples prior to the selected sample will not be loaded. It also follows that no sub-folders will be loaded as well.
3. Select the option `+ New Kit Name` and press K3. Use E3 to select which row you are editing. Use E2 to select the numbers and alphabets. Once done, use E3 to go back to the last row and select `OK`. Press K3. 
4. Press K1 to go back to the main screen. 
5. The first two lines of the screen show the origin and destination respectively
6. Use E2 to scroll through the samples, which will play when highlighted. 
7. Press K2 to select the sample for inclusion in the new kit. Selected samples are indicated by a plus sign (`+`). 
8. Press K2 to de-select the sample. 
9. Once you have decided which samples you wish to include, press K1 + K2. This will create a new directory with the name of the new kit and copy the samples to that folder. You will see an `S` in the bottom right corner of the screen when this is done. **Note**: if you use the same new kit name as an existing folder, it will add to the samples already inside. However, any samples with the same name will be overwritten. 

## To-do

1. Fix bugs

## Roadmap

I am not sure how much more I wish to add to a rather straightforward utility script, but some ideas are:

1. multiple source folders;
2. options, *eg*, to choose to overwrite all existing files in existing kit folders. 
3. renaming samples.

## Install

from maiden:

`;install https://github.com/fardles/kitns`

## Credits

Many thanks to @markeats for the inimitable Timber, to @its_your_bedtime for nisp which set this whole thing going and for code inspiration, to @infinitedigits for parts of mx.sample that I borrowed. 

It's a bit weird to say so much for what is probably a trivial script to so many people here on lines, but I've been so inspired that this little script is sort of a love letter to the community, to monome, and my little norns shield. I get many warm feelings from just being in lines, and being able to contribute this little script is, I hope, just the start as I keep learning and growing.

## Postscript

Just some process notes:

1. Lua's ``table`` functions start from 1 while some engines like Timber start counting things like samples from 0. This led to some confusion on my part and some mental gymnastics around adding and subtracting for various comparisons to make sense!
2. Some of the documentation around `fileselect` and `textentry` is incomplete -- I understand many of the docs are being overhauled, and should probably consider contributing to this effort! Some of the libraries are really great to use. I learned how to use `textentry` largely from `wifi.lua`. 
3. I am in awe of how concise and well-constructed some of the scripts for norns are. Just reading through the files for Timber fills me with awe for the effort it must have taken. The same goes for all of the scripts I referred to in the course of trying to code this little utility. 







