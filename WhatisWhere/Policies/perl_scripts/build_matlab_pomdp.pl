#!/usr/local/bin/perl
#check arguments
if(@ARGV!=2){usage();exit();}else{
    open INPUT, "<", "$ARGV[0]" or die $!;
    open OUTPUT, ">", "$ARGV[0]" . "csv" or die $!;
    #loop through lines
    while (<INPUT>) {
        #Skip commented lines
        if($_ =~ /^\s*#/){next;}chomp;
            $_ =~s/ /, /g;
        
        #Checking that values are set as type reward.
        if($_ =~ m/values: /){if($_ =~ m/reward/){print "Values are correct.\n";}else{valerror();exit();}next;}
        if($_ =~ m/discount/){
            print "Discount factor located.\n";
            $_ =~s/[^\d.]//g;
            print OUTPUT "discount = $_;\n";next;}
        if($_ =~ m/states/){
            print "Building state list.\n";
            $_ =~ s/states: //g;
            @s=split(/ /,$_);
            $i=1;
            #THIS LINE NEEDS TO BE MODIFIED TO CREATE A HASHTABLE IN MATLAB. IF ITS LEFT COMMENTED THE POMDP IS ASSUMED TO HAVE STATES NAMED FROM 1.. $ss (LOSING THE .POMDP DEFINED NAMES)
            foreach $s(@s){#print OUTPUT "S[$i] = \"$s\";\n";
                $states{"$s"} = $i;$i++;}next;}
        if($_ =~ m/actions/){
            print "Building action list.\n";
            $_ =~ s/actions: //g;
            @a=split(/ /,$_);
            $i=1;
            #SEE COMMENT ON STATE SPACE CONSTRUCTION (LOST ACTION NAMES)
            foreach $a(@a){#print OUTPUT "A[$i] = \"$a\";\n";
                $actions{"$a"} = $i;$i++;}next;}
        if($_ =~ m/observations/){
            print "Building observation list.\n";
            $_ =~ s/observations: //g;
            @o=split(/ /,$_);
            $i=1;
            #SEE COMMENT ON STATE SPACE CONSTRUCTION (LOST OBSERVATION NAMES)
            foreach $o(@o){#print OUTPUT "Om[$i] = \"$o\";\n";
                $observations{"$o"} = $i;$i++;}next;}
        if($_ =~ m/start/){
            print "Building starting state distribution.\n";
            #extra line because in Tony's format starting state isn't defined in a single line
            $dist=<INPUT>;
            @s=split(/ /,$dist);
            $i=1;
            #Pre-allocate memory
            $ss = scalar keys %states;
            print OUTPUT "P=zeros(1,$ss);\n";
            foreach $s(@s){if($s =~ m/^0\.000000/){next;}print OUTPUT "P($i) = $s;\n";$i++;}
            #At this point we should be ready to build T,O,R shells.
            $sa = scalar keys %actions;
            $so = scalar keys %observations;
            if(($ss==0)||($sa==0)||($so==0)){ordererror();exit();}
            print OUTPUT "T=zeros($sa,$ss,$ss);\n";
            print OUTPUT "O=zeros($sa,$ss,$so);\n";
            print OUTPUT "R=zeros($sa,$ss,$ss,$so);\n";
            next;
        }
        #Build transition, observation, and reward matrices
        #Transition Matrix
        if($_ =~ m/^T: /){
            $_ =~ s/T: //g;
            $_ =~ s/: //gi;
            @sec=split(/ /,$_);
            #We already defined the shell above so it can be skipped
            if($sec[3] =~ m/^0\.000000/){next;}
            #Action
            if($sec[0] =~ m/\*/){$exec_action=":";}
            else{$exec_action=($actions{$sec[0]});}
            #States
            if($sec[1] =~ m/\*/){$start_state=":";}
            else{$start_state=($states{$sec[1]});}		
            if($sec[2] =~ m/\*/){$end_state=":";}
            else{$end_state=($states{$sec[2]});}
            print OUTPUT "T($exec_action,$start_state,$end_state)=$sec[3];\n";
        }
        
        #Observation Matrix
        #Code is analog to Transition building
        if($_ =~ m/^O: /){
            $_ =~ s/O: //g;
            $_ =~ s/: //gi;
            @sec=split(/ /,$_);
            if($sec[3] =~ m/^0\.000000/){next;}
            #Action
            if($sec[0] =~ m/\*/){
                $exec_action=":";}
            else{$exec_action=($actions{$sec[0]});}
            #States
            if($sec[1] =~ m/\*/){
                $start_state=":";}
            else{$start_state=($states{$sec[1]});}
            if($sec[2] =~ m/\*/){
                $observation=":";}
            else{$observation=($observations{$sec[2]});}
            print OUTPUT "O($exec_action,$start_state,$observation)=$sec[3];\n";
        }
        #Reward Matrix
        if($_ =~ m/^R: /){
            $_ =~ s/R: //g;
            $_ =~ s/: //gi;
            @sec=split(/ /,$_);
            if($sec[4] =~ m/^0\.000000/){next;}
            #Action
            if($sec[0] =~ m/\*/){
                $exec_action=":";}
            else{$exec_action=($actions{$sec[0]});}
            #States
            if($sec[1] =~ m/\*/){
                $start_state=":";}
            else{$start_state=($states{$sec[1]});}
            if($sec[2] =~ m/\*/){
                $end_state=":";}
            else{$end_state=($states{$sec[2]});}
            if($sec[3] =~ m/\*/){
                $observation=":";}
            else{$observation=($observations{$sec[2]});}
            print OUTPUT "R($exec_action,$start_state,$end_state,$observation)=$sec[4];\n";
        }
    }
    close (INPUT); 
    #parsing finished. Wrap it up into a struct
    #make space for configuration size (cs) which needs to be manually set
    print OUTPUT "cs=-1;\n";
    #INVERT COMMENTING IF STATE NAMING HAS BEEN FIXED (SEE ABOVE)
    #print OUTPUT "POMDP = struct('A',A,'S',S,'OSpace',Om,'R',R,'O',O,'T',T,'prior',P,'disc',discount);\n";
    print OUTPUT "$ARGV[1]_POMDP = struct('R',R,'O',O,'T',T,'disc',discount,'prior',P,'cs',cs);\n";
    #delete everything we don't need anymore
    #print OUTPUT "clear A;clear S;clear Om;clear R;clear P;clear O;clear T;clear discount;";
    print OUTPUT "clear R;clear P;clear O;clear T;clear discount;clear cs;";
    print OUTPUT "disp('Done.');";
    print OUTPUT "disp('DONT FORGET THAT CONFIGURATION SIZE (CS) MUST BE MANUALLY SET (In paper cs=24).');";
    close (OUTPUT);
    print "Done.\n";
}
#when script is incorrectly used
sub usage{ print "Usage: perl build_matlab_pomdp pomdp.POMDP output_prefix\n";}
sub valerror{ print ".POMDP Error: Parser only works for reward type POMDPs.\n";}
sub ordererror{ print "Order Error: Discount, Actions, States, and Start distribution must be defined before building transition, observation, and reward matrices.\n";}
