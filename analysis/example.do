// stata cannot handle compressed csv files directly, so unzip first to a plain csv file
!gunzip output/input.csv.gz

// now import the uncompressed csv using delimited
import delimited using output/input.csv


// your analysis code goes here


// all dta file outputs should be saved using `gzsave` and a .dta.gz extension
// In subsequent actions, use `gzuse` to load them.
gzsave output/stata.dta.gz
