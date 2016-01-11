# open files for read and write
my $in_file = "prelab.mt0";
my $out_file = "prelab.txt";
open my $IN, "<", $in_file; # open for reading
open my $OUT, ">", $out_file; # open for writing

# count for number of input variable
$var_input_num = @ARGV; # return the length of the input var array

$flag_var_row = 1; # whether this is variable row or not
$var_row_num = 0;
$data_row_num = 0;
$i = 0; $j = 1;
foreach(<$IN>)
{
	chomp $_;
	if($_ =~ m/^\$/) {next;} # commend line start with '$', ignored
	elsif($_ =~ m/^\./) {next;} # title line of simulation start with '.', ignored
	elsif($_ =~ m/^\s*$/) {next;} # empty line, ignored
	
	### Take in the Variable & Data each in a linear array ###
	if($flag_var_row) # if this is the variable row, but not the end
	{
		@temp = split /\s+/, $_;
		$len = @temp;
		# num/data index from 1, have 1 additional element!!!
		for($j = 1; $j < $len; $j++) {$var[$i] = $temp[$j]; $i++;}
		$var_row_num++;
	}
	else # if this is not the variable row, the data row
	{
		my@temp = split /\s+/, $_;
		$len = @temp;
		for($j = 1; $j < $len; $j++) {$data[$i] = $temp[$j]; $i++;}
		$data_row_num++;
	}
	# can't use /XX$/ to find string end with "XX"???
	if($_ =~ m/alter#/) {$flag_var_row = 0; $i = 0;} # the end of the variable row
}

# testing code here...
# printf $OUT "$var_input_num\n";
# printf $OUT "$var[6]\n";
# printf $OUT "$data[0]\n";

# identify index of variable ***subset***
$var_num = @var;
$i = 0; $j = 0;
foreach $var_input (@ARGV)
{
	for($i = 0; $i < $var_num; $i++)
	{
		if($var_input eq $var[$i]) {$var_ex_index[$j] = $i; $j++;}
	}
}
$var_ex_index_len = @var_ex_index;
# printf $OUT "@var_ex_index\n";

# print out data in the desired format!!!
for($i = 0; $i < $var_input_num; $i++)
{
	if($i == $var_input_num - 1) {printf $OUT "$ARGV[$i]\n";}
	else {printf $OUT "$ARGV[$i],";}
}

$data_row_num = $data_row_num / $var_row_num;
# printf $OUT "$data_row_num\n";
for($i = 0; $i < $data_row_num; $i++)
{
	for($j = 0; $j < $var_ex_index_len; $j++)
	{
		$data_print = $data[$i * $var_num + $var_ex_index[$j]];
		if($data_print eq "failed") {$data_print = NaN;}
		if($j == $var_ex_index_len - 1) {printf $OUT "$data_print\n";}
		else {printf $OUT "$data_print,";}
	}
}

# close files
close $IN;
close $OUT;
