# kitns

> *KIT*s for *N*orn*S*

A basic sample kit creator for norns. 

I made this as a simple utility and an exercise in coding. This is an utility that is meant to help with scripts like gridstep, timber, and nisp, which give the option of loading a whole folder of samples. It's a little step forward in giving back to this wonderful community. 

I'm not a coder by any means, more like a code-scavenger. Many thanks to scripts like mx.samples, timber, and nisp, from which I have culled much of the functionality of the script. Many thanks also to the wonderful libraries on the norns, in particular,`fileselect` and `textentry`.

## Requirements

- norns
- engine: timber

## Documentation

1. Navigate to `PARAMS` then `EDIT`
2. Select the option `+ Load Folder` and press K3. Navigate to the desired folder. In that folder, use E2 to highlight the first sample which you wish to load and press K3. **Note**: The samples are loaded from the selected sample and following, and any samples prior to the selected sample will not be loaded.
3. Select the option `+ New Kit Name` and press K3. Use E3 to select which row you are editing. Use E2 to select the numbers and alphabets. Once done, use E3 to go back to the last row and select `OK`. Press K3. 
4. Press K1 to go back to the main screen. 
5. The first two lines of the screen show the origin and destination respectively
6. Use E2 to scroll through the samples, which will play when highlighted. 
7. Press K2 to select the sample for inclusion in the new kit. Selected samples are indicated by a plus sign (+). 
8. Press K2 to de-select the sample. 
9. Once you have decided which samples you wish to include, press K1 + K2. This will create a new directory with the name of the new kit and copy the samples to that folder. **Note**: if you use the same new kit name as an existing folder, it will add to the samples already inside. However, any samples with the same name will be overwritten. 

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







