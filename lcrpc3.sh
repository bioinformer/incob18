#!/bin/bash
# Before running on SEG server
cat H1vars.fasta | tr -s ' ' '_' | tee H1var1.fasta
grep '^>' H1var1.txt | sed -e 's/>/> /g' | awk '{print $2}' | tee H1hdr.txt
# Split MULTI fasta into Single FASTA files.
awk '/^>sp/ {OUT=substr($0,2) ".fa"}; {print >> OUT; close(OUT)}' H1var1.fasta 

# Store the SEG output as H1seg0.txt and Split into 3 SEG modes separate Files as follows,
awk '/low complexity regions: SEG 12 2.2 2.5/{flag=1; next} /low complexity regions: SEG 25 3.0 3.3/{flag=0} flag' H1seg0.txt | \
tee H1seg1.txt
awk '/low complexity regions: SEG 25 3.0 3.3/{flag=1; next} /low complexity regions: SEG 45 3.4 3.75/{flag=0} flag' H1seg0.txt | \
tee H1seg2.txt
awk '/low complexity regions: SEG 45 3.4 3.75/{flag=1; next} /low complexity regions: SEG 12 2.2 2.5/{flag=0} flag' H1seg0.txt | \
tee H1seg3.txt

# RUN below script to compute LOWER case (LCR) and UPPER case (Non-LCR) regions.
awk 'NF{print $0 ".fa"}' H1hdr.txt | tee H1fsapp.txt     

while read histone                                                               

do

        echo "$histone"

        nawk '{lu=gsub("[A-Z]","");ll=gsub("[a-z]","");u+=lu;l+=ll;printf("Line [%d]: u->[%d] l->[%d]\n", \

FNR,lu,ll)}END { print "Total:: upper:" u " lower:" l}' "$domain"

done < H1fsapp.txt

# To be Edited soon. Until then, try Yourself!






