# open files for read and write
my $in_file = "prelab.mt0";
my $out_file = "prelab.txt";
open my $IN, "<", $in_file; # open for reading
open my $OUT, ">", $out_file; # open for writing

# count for number of input variable
$var_input_num = @ARGV; # return the length of the array

printf $OUT "$var_input_num\n";

$i = 0;
foreach(<$IN>)
{
	chomp $_;
	if($_ =~ m/^\$/) {next;} # commend line start with '$', ignored
	elsif($_ =~ m/^\./) {next;} # title line of simulation start with '.', ignored
	$data[$i] = $_;
	$i++;
}

my @temp = split /\s+/, $data[2];
printf $OUT "$temp[1]\n";

# close files
close $IN;
close $OUT;

