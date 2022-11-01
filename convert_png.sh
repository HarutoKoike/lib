#!/bin/bash
#while IFS= read -r line; do    
#    echo "$line"
#    #    line1=${line%".eps"}
#    line1=${line/".eps"/".png"}
#    #convert -trim -colorspace RGB -density 200 -quality 100 -alpha deactivate $line $line1
    #convert $line $line1
    convert /Volumes/spel_data/20Users/koike/plot/cluster/MPCrossing/2004/01/MPCrossing_20040101_115300.eps /Volumes/spel_data/20Users/koike/plot/cluster/MPCrossing/2004/01/MPCrossing_20040101_115300.png
#    #rm $line
#done < list.txt
