#!/usr/bin/perl
use Expect;
sub test{
my $ssh=shift;
print "+++++++++++++++++++++++++++++++++++++++++++\n";
$ssh->spawn("ssh qat-server-114 -l root");
@result{ "position", "error", "match", "before", "after" } =
$ssh->expect(30,
            [ "password:", sub { my $fh = shift; $fh->send("tester\n"); } ],
            [ "Are you sure you want to continue connecting", sub { my $fh = shift; $fh->send("yes\n"); } ],
            [ "Do you want to change the host key on disk", sub { my $fh = shift; $fh->send("no\n"); } ],
            [ "Last login", sub { my $fh = shift; $fh->expect(15, '#'); $status = "success"; } ],
            [ "Authentication successful", sub { my $fh = shift; $fh->expect(15, '#'); $status = "success"; } ],
            [ eof => sub { print "Premature EOF on ssh session\n"; $status = "eof"; } ],
            [ timeout => sub { print "Timeout on ssh session\n"; $status = "timeout"; } ]
        );
print "$_ = $result{$_}\n" foreach ( keys %result );
}
sub main{
my $ssh=new Expect;
test($ssh);
$ssh->hard_close();
test($ssh);
}
main();
#$ssh->soft_close();
