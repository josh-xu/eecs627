# open files for read and write
my $in_file = "prelab.mt0";
my $out_file = "prelab.txt";
open my $IN, "<", $in_file; # open for reading
open my $OUT, ">", $out_file; # open for writing

# count for number of command line input variable
$var_input_num = @ARGV; # return the length of the input var array

# ignore redundant part, parse var and data into two arrays
$flag_var_row = 1; # whether this line is variable row or not
$var_row_num = 0;
$data_row_num = 0;
$i = 0; $j = 1;
foreach(<$IN>)
{
	chomp $_; # separate content with each line by "\n"
	if($_ =~ m/^\$/) {next;} # commend line start with '\$', ignored
	elsif($_ =~ m/^\./) {next;} # title line of simulation start with '\.', ignored
	elsif($_ =~ m/^\s*$/) {next;} # empty line, should be ignored
	
	### Take in the Variable & Data each in a linear array ###
	if($flag_var_row) # if this is the variable row, but not the end
	{
		my @temp = split /\s+/, $_; # split by empty space
		my $len = @temp;
		# split num/data index from 1, have 1 additional element!!!
		for($j = 1; $j < $len; $j++) {$var[$i] = $temp[$j]; $i++;}
		$var_row_num++;
	}
	else # if this is not the variable row, the data row
	{
		my @temp = split /\s+/, $_;
		my $len = @temp;
		for($j = 1; $j < $len; $j++) {$data[$i] = $temp[$j]; $i++;}
		$data_row_num++;
	}
	# end with alter#, '\#', notice several spaces after alter#...
	if($_ =~ m/alter\#\s+$/) {$flag_var_row = 0; $i = 0;} # the end of the variable row
}

# identify index of variable ***subset*** in the same order as command line input
$var_num = @var; # total var nums in mt0 file
$i = 0; $j = 0;
foreach $var_input (@ARGV)
{
	for($i = 0; $i < $var_num; $i++)
	{
		if($var_input eq $var[$i]) {$var_ex_index[$j] = $i; $j++;}
	}
}
$var_ex_index_len = @var_ex_index;

# print out var in the desired format!!!
for($i = 0; $i < $var_input_num; $i++)
{
	if($i == $var_input_num - 1) {printf $OUT "$ARGV[$i]\n";}
	else {printf $OUT "$ARGV[$i],";}
}
# print out data in the desired format!!!
$data_row_num = $data_row_num / $var_row_num; # num of measured data sets
for($i = 0; $i < $data_row_num; $i++)
{
	for($j = 0; $j < $var_ex_index_len; $j++)
	{
		my $data_print = $data[$i * $var_num + $var_ex_index[$j]]; # access as two-dimension array
		if($data_print eq "failed") {$data_print = "NaN";}
		if($j == $var_ex_index_len - 1) {printf $OUT "$data_print\n";}
		else {printf $OUT "$data_print,";}
	}
}

# close files
close $IN;
close $OUT;