# SWAN_example
Example Matlab scripts for prepping and viewing SWAN model runs.

This resides in my ../proj/2015_Sandwich/CCBay_Modeling/SWAN_example folder on my desktop.

These draw on some utility scripts written by Dave Thompson, USGS, St. Petersburg.

---
#### Run SWAN
`CCB_200x200_v1.swn` - SWAN input file to run a stationary case

Input:
* `Sand200x200_v1.cgd` - Coordinates of the model grid
* `Sand200x200_v1.bot` - Depths at coordinate locations

Output:
* `*.mat` - Model output for various parameters in
---
#### Look at the model output

`swan_look.m` - Script to load the `.mat` files and make a quick plot
