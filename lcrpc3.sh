#!/bin/bash
# Before running on SEG server
cat H1vars.fasta | tr -s ' ' '_' | tr -s '-' '_' | tr -s '/' '_' | tee H1var1.fasta
grep '^>' H1var1.fasta | sed -e 's/>/> /g' | awk '{print $2}' | awk 'NF{print $0 ".fa"}' | tee H1hdr.txt 
# Split MULTI fasta into Single FASTA files.
awk '/^>sp/ {OUT=substr($0,2) ".fa"}; {print >> OUT; close(OUT)}' H1var1.fasta 

# Make three Sub directories for Each of 3 SEG modes Output
mkdir -p seg1 seg2 seg3
grep -c '^>' H1seg0.txt
# 30

# Store the SEG output as H1seg0.txt and Split into 3 SEG modes separate Files as follows,
awk '/low complexity regions: SEG 12 2.2 2.5/{flag=1; next} /low complexity regions: SEG 25 3.0 3.3/{flag=0} flag' H1seg0.txt | \
tee ./seg1/H1seg1.fasta
awk '/low complexity regions: SEG 25 3.0 3.3/{flag=1; next} /low complexity regions: SEG 45 3.4 3.75/{flag=0} flag' H1seg0.txt | \
tee ./seg2/H1seg2.fasta
awk '/low complexity regions: SEG 45 3.4 3.75/{flag=1; next} /low complexity regions: SEG 12 2.2 2.5/{flag=0} flag' H1seg0.txt | \
tee ./seg3/H1seg3.fasta

grep -c '^>' H1seg1.fasta 
grep -c '^>' H1seg2.fasta 
grep -c '^>' H1seg3.fasta # Check ALL 3 are = 10.

# RUN below script to compute LOWER case (LCR) and UPPER case (Non-LCR) regions.
while read histone                                                               
do
        echo "$histone"

        nawk '{lu=gsub("[A-Z]","");ll=gsub("[a-z]","");u+=lu;l+=ll;printf("Line [%d]: u->[%d] l->[%d]\n", \
FNR,lu,ll)}END { print "Total:: upper:" u " lower:" l}' "$histone"
done < H1hdr.txt | tee initial.txt

# Demarcate each SEG mode output by its Number, 1 or 2 or 3
cd seg1
sed -i '/^>sp/ s/$/_seg1/' H1seg1.fasta
grep '^>' H1seg1.fasta | sed -e 's/>/> /g' | awk '{print $2}' | awk 'NF{print $0 ".fa"}' | tee H1S1hdr.txt
cat H1seg1.fasta | awk 'NF>0' | sed -e 's/-//g' | sed -e '/^>sp/! s/[0-9]//g' | tr -d '\n' | tr -d ' ' | \
sed -e 's/_seg1/_seg1\n/g' | sed -e 's/>sp/\n>sp/g' | awk 'NF>0' | tee H1S1LCR.fasta
awk '/^>sp/ {OUT=substr($0,2) ".fa"}; {print >> OUT; close(OUT)}' H1S1LCR.fasta
# Compute PERCENTAGE of number of LCRs or LowerCaseAlphabets
while read histone                                                               
do
        echo "$histone"

        nawk '{lu=gsub("[A-Z]","");ll=gsub("[a-z]","");u+=lu;l+=ll;printf("Line [%d]: u->[%d] l->[%d]\n", \
FNR,lu,ll)}END { print "Total:: upper:" u " lower:" l}' "$histone"
done < H1S1hdr.txt | tee raw01.txt
sed 's/[][%d]/ /g' raw01.txt | tee raw02.txt
grep -B1 '^Total' raw02.txt | grep -v 'Total' | grep '^Line' | tee raw03.txt 
cat raw03.txt | awk '$8 = ($7*100)/($5+$7)' | tee raw04.txt

cd ..
cd seg2
sed -i '/^>sp/ s/$/_seg2/' H1seg2.fasta
grep '^>' H1seg2.fasta | sed -e 's/>/> /g' | awk '{print $2}' | awk 'NF{print $0 ".fa"}' | tee H1S2hdr.txt
cat H1seg2.fasta | awk 'NF>0' | sed -e 's/-//g' | sed -e '/^>sp/! s/[0-9]//g' | tr -d '\n' | tr -d ' ' | \
sed -e 's/_seg2/_seg2\n/g' | sed -e 's/>sp/\n>sp/g' | awk 'NF>0' | tee H1S2LCR.fasta
awk '/^>sp/ {OUT=substr($0,2) ".fa"}; {print >> OUT; close(OUT)}' H1S2LCR.fasta
# Compute PERCENTAGE of number of LCRs or LowerCaseAlphabets
while read histone                                                               
do
        echo "$histone"

        nawk '{lu=gsub("[A-Z]","");ll=gsub("[a-z]","");u+=lu;l+=ll;printf("Line [%d]: u->[%d] l->[%d]\n", \
FNR,lu,ll)}END { print "Total:: upper:" u " lower:" l}' "$histone"
done < H1S2hdr.txt | tee raw01.txt
sed 's/[][%d]/ /g' raw01.txt | tee raw02.txt
grep -B1 '^Total' raw02.txt | grep -v 'Total' | grep '^Line' | tee raw03.txt 
cat raw03.txt | awk '$8 = ($7*100)/($5+$7)' | tee raw04.txt
cd ..

cd seg3
sed -i '/^>sp/ s/$/_seg3/' H1seg3.fasta
grep '^>' H1seg3.fasta | sed -e 's/>/> /g' | awk '{print $2}' | awk 'NF{print $0 ".fa"}' | tee H1S3hdr.txt
cat H1seg3.fasta | awk 'NF>0' | sed -e 's/-//g' | sed -e '/^>sp/! s/[0-9]//g' | tr -d '\n' | tr -d ' ' | \
sed -e 's/_seg3/_seg3\n/g' | sed -e 's/>sp/\n>sp/g' | awk 'NF>0' | tee H1S3LCR.fasta
awk '/^>sp/ {OUT=substr($0,2) ".fa"}; {print >> OUT; close(OUT)}' H1S3LCR.fasta
# Compute PERCENTAGE of number of LCRs or LowerCaseAlphabets
while read histone                                                               
do
        echo "$histone"

        nawk '{lu=gsub("[A-Z]","");ll=gsub("[a-z]","");u+=lu;l+=ll;printf("Line [%d]: u->[%d] l->[%d]\n", \
FNR,lu,ll)}END { print "Total:: upper:" u " lower:" l}' "$histone"
done < H1S3hdr.txt | tee raw01.txt
sed 's/[][%d]/ /g' raw01.txt | tee raw02.txt
grep -B1 '^Total' raw02.txt | grep -v 'Total' | grep '^Line' | tee raw03.txt 
cat raw03.txt | awk '$8 = ($7*100)/($5+$7)' | tee raw04.txt
cd ..

awk '{print "\t"$8}' ./seg1/raw04.txt | tee H1under.txt
awk '{print "\t"$8}' ./seg2/raw04.txt | tee H1fair.txt 
awk '{print "\t"$8}' ./seg3/raw04.txt | tee H1over.txt
paste H1hdr.txt H1under.txt H1fair.txt H1over.txt | tee H1pclcr.xls
# Open H1pclcr.txt FILE in EXcel or LibreOffice CALC format




 
 





