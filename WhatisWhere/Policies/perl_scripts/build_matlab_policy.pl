#!/usr/local/bin/perl
#
# Julian Jara-Ettinger
# Department of Brain and Cognitive Sciences
# Massachusetts Institute of Technology
# Supplemental Code
#
# Convert appl policy file to a MATLAB BToM struct
#
# Usage: perl build_matlab_policy policyfile.policy output_prefix
#
# Script will create a file called output_prefix_matlab_btom.m
# that builds a structure called output_prefix_btom in matlab
#
print "Converting appl policy to MATLAB struct...\n";
#check arguments
if(@ARGV!=2){usage();exit();}else{
 my($vsize);
 my($vamount);
 open INPUT, "<", "$ARGV[0]" or die $!;
 open OUTPUT, ">", "$ARGV[1]" . "_matlab_btom.m" or die $!;
 print OUTPUT "disp('Building BToM struct from build_matlab_policy.pl output...');\n";
 $vec_counter=0;
 #loop through lines
 while (<INPUT>) {
   if(($_=~ m/^\<\?xml/)||($_=~ m/^\<Policy/)||($_=~ m/^\<\/AlphaVector/)){next;}chomp;
   #get metadata
   if($_=~ m/\<AlphaVector/){
     @meta=split(/ /,$_);
       for $md(@meta){
	if($md=~ m/vectorLength/){$md=~ s/[^\d.]//g;$vsize=$md;}
	if($md=~ m/numVectors/){$md=~ s/[^\d.]//g;$vamount=$md;}
       }
   }
   #Alpha-Vector parsing
   if($_=~ m/\<Vector/){
     @pts=split(/ /,$_);
     $pts[1]=~s/[^\d.]//g;
     $action[$vec_counter]=$pts[1];
     $pts[2] =~s/[^-\d.]//g;
     $pts[2] =~ s/.//;
     $vecs[$vec_counter][0]=$pts[2];
     #store the rest of the values
     for ($i=3;$i<=($vsize+3);$i++){
	$vecs[$vec_counter][$i-2]=$pts[$i];
     }
     $vec_counter++;
   }
 }
 close(INPUT);
 #Construct action array
 print OUTPUT "actions=[";
 for ($i=0; $i<$vamount; $i++){print OUTPUT "$action[$i] ";}
 print OUTPUT "];\n";
 #Construct alpha-vector arrays
 print OUTPUT "alphavecs=zeros($vamount,$vsize);\n";
 for ($i=0; $i<$vamount; $i++){
   $s1=$i+1;
   print OUTPUT "alphavecs($s1,:)=[";
   for ($j=0; $j<$vsize; $j++){print OUTPUT "$vecs[$i][$j] ";}
   print OUTPUT "];\n";}
 #wrap it up in a struct
 print OUTPUT "$ARGV[1]_btom=struct('actions',actions,'vectors',alphavecs);\n";
 print OUTPUT "clear actions; clear alphavecs;\n";
 print OUTPUT "disp('Done. Actions and Alpha-Vectors are in BToM struct.');\n";
 close(OUTPUT);
 print "Done.\n";
}
sub usage{ print "Usage: perl build_matlab_policy policyfile.policy output_prefix\n";}
