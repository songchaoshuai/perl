#!/usr/bin/perl
package aa;
use strict;
use warnings;
BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);
    our $VERSION = 4.008000001;
    our @EXPORT = qw(out
                     in);
}
my ($volume, $directory, $file);
BEGIN {
    use File::Spec;
    ($volume, $directory, $file) = File::Spec->splitpath(__FILE__);
}

sub out{
printf("out:__FILE__,__LINE__volume:$volume directory:$directory file:$file\n");
}
sub in{
printf("in:volume:$volume directory:$directory file:$file\n");
}
1;
