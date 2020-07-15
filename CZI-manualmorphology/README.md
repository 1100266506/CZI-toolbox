Manual morphology prep script

The follow script is written ImageJ and is meant to take a CZI zstack image
and reduce background, equalize histograms, and apply a nondestructive grid
 such that it can be manually analyzed for microglia morphology.

Microlgia manual morpholopgy run script

The following script was an attempt to automate 2D microlgia morphology analysis
in 2D. It takes the processed MIPs from the moanual morphology prep script and
attempts to calculate overall area and perimeter, and save the data in a csv.
The csv can then be ran in MATLAB to calculate circularity
