# SWAN_example
Example Matlab scripts for prepping and viewing SWAN model runs.

This resides in my ../proj/2015_Sandwich/CCBay_Modeling/SWAN_example folder on my desktop.

These draw on some utility scripts written by Dave Thompson (USGS, St. Petersburg) but does not include his full suite of helpful code.

---
#### Make a grid
`swan_makeGrid.m` - Do the math to determine grid point locations and write the grids.

This code works in *x,y* coordinates (e.g., UTM) and makes a rectangular grid with an orgin at *xpc, ypc* at some angle *alp* with size *xlenc, ylenc* and spacing *dxc, dy*. After specifying this, the grid size is *mxy* by *myc* grid points. Pro hint: don't make a square grid with *mxc = myc*....it is easier to track the orientation of a rectangular grid. You may need to iterate with figure showing your bathymetry input until you get the grid located and oriented correctly.

This code does not do the interpolation of bathymetry to the grid points. You can do that externally with e.g. Surfer, GlobalMapper, QGIS, or ArcGIS....or you can import the bathy to Matlab and use griddata.

Also, this code does not help converting data to/from UTM (or other planar, equal-area projection) to lat/lon. However, I have included Rich Signell's `utm2ll.m` and `ll2utm.m` functions in the repo if you need to do that. 

Input:
* `Coarse_grid_Z.txt` - Text file with 2D array of depths at all of the grid points. This needs to be created externally at the locations specified in `coarse_grid.dat` after that file has been created midway through the script.

Output:
* `coarse_box.dat` - Text file with four corner points. You can use these to visualize where the grid will be wrt to a shoreline or your bathy data.
* `coarse_grid.dat` - Text file with 2D array of all of the grid points.
* `Sand200x200_v1_check.cgd` - Coordinates of the model grid
* `Sand200x200_v1_check.bot` - Depths at coordinate locations

---
#### Run SWAN
`CCB_200x200_v1.swn` - SWAN input file to run a stationary 2D case

Input:
* `Sand200x200_v1.cgd` - Coordinates of the model grid (created above)
* `Sand200x200_v1.bot` - Depths at coordinate locations (created above)

Output:
* `*.mat` - Model output for various parameters in
---
#### Look at the model output

`swan_look.m` - Script to load the `.mat` files and make a quick plot
