#!/usr/bin/perl
use lib '/home/chaoshuai/study/perl/module/lib';
use aa;
my ($volume, $directory, $file);
BEGIN {
    use File::Spec;
    ($volume, $directory, $file) = File::Spec->splitpath(__FILE__);
}
printf("volume:$volume directory:$directory file:$file\n");
printf("++++++++++++++++++++++++++++\n");
out();
in();
printf("++++++++++++++++++++++++++++\n");
exit 0;

