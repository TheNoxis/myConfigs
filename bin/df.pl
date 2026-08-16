#! /usr/bin/perl
#
#use warn
#use strict
# use utf8;
use Term::ANSIColor;

#my @DF = `df -hP | grep -E '^/dev/|^Filesystem' | sort -k 6`;
my @DF = `df -hP | grep -E '^/dev/' | sort -k 6`;

sub graph_percent {
	my $ret = "";
	my $pcent = $_[0] / 5;
	for ($i=0; $i<$pcent; $i++) {
		$ret .= "#";
	}
	return $ret
}
use Term::ANSIColor qw(:constants);
sub graph_percent2{
	my $ret = "";
	my $pcent = $_[0] / 5;
	printf '│[';
	for ($i=0; $i<=$pcent; $i++) {
		if( $i >= 17 ) {
			printf RED "▓";
		} elsif( $i >= 12 ) {
			printf YELLOW "▓";
		} else {
			printf GREEN "▓";
		}
	}
	for ($i=$pcent; $i<19; $i++) {
		printf " ";
	}
	printf RESET ']│';
	return $ret
}

printf("┌───┬───────────────────────────┬───────┬──────────────────────┬──────────────┬───────┐\n");
printf("│%2s │ %-25s │ %5s │ %20s │ %5s - %4s │ %5s │\n", "#", "Mounted", "Used", "", "Free", "Use%", "Size");
printf("├───┼───────────────────────────┼───────┼──────────────────────┼──────────────┼───────┤\n");
for my $i (0..$#DF) {
	chomp $i;
	($dev, $size, $used, $free, $usePercent, $mount ) = split( " ", $DF[$i] );
	printf("│%2d │ %-25s │", $i, $mount);
	printf(" %5s ", $used);
#	printf("[%-20s]", &graph_percent($usePercent));
	&graph_percent2($usePercent);
	printf(" %5s ", "$free");
	printf("%6s ", "($usePercent)");
	printf("│ %5s ", $size);
	printf("│\n");
}
printf("└───┴───────────────────────────┴───────┴──────────────────────┴──────────────┴───────┘\n");
