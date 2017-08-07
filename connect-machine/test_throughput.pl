#!/usr/bin/perl
=comment
* USAGE:
        ./automation2_dm.pl <.cfg file>

  NOTE:
	Please make sure all the relevant perl packages are installed, like Expect/Switch, etc...
	Refer clc64-upstream-automation.cfg file for more details on the configuration parameters.
=cut
use strict;
use warnings;
use Switch;
use Cwd;
use Expect;
#use Net::SSH::Expect;
use Time::HiRes qw(time);



sub ssh_connect
{
    my $ssh = shift;
    my $target = shift;
    my $crb_pwd = shift;
    my $port = shift;
    my $status = "trying";
      
    &system_do("sed -i '/^$target /d' ~/.ssh/known_hosts");
    #Spawn an ssh session
    print "\nSpawing ssh session on $target\n";
    if(defined($port)){
        $ssh->spawn ("ssh $target -l root -p $port") or
            log_error ("Cannot spawn ssh session!"),
            print "cannot spawn ssh session to $target\n",
            return;
    }else{
        $ssh->spawn ("ssh $target -l root") or
            log_error ("Cannot spawn ssh session!"),
            print "cannot spawn ssh session to $target\n",
            return;
    }
    
    do {
        $ssh->expect(30,
            [ "assword:", sub { my $fh = shift; $fh->send("$crb_pwd\n"); } ],
            [ "Are you sure you want to continue connecting", sub { my $fh = shift; $fh->send("yes\n"); } ],
            [ "Do you want to change the host key on disk", sub { my $fh = shift; $fh->send("no\n"); } ],
            [ "Last login", sub { my $fh = shift; $fh->expect(15, '#'); $status = "success"; } ],
            [ "Authentication successful", sub { my $fh = shift; $fh->expect(15, '#'); $status = "success"; } ],
            [ eof => sub { print "Premature EOF on ssh session\n"; $status = "eof"; } ],
            [ timeout => sub { print "Timeout on ssh session\n"; $status = "timeout"; } ]
        );
    } while ($status =~ /trying/);
    # Make sure we are running bash
    if ($status =~ /success/) {
        $ssh->send("exec /bin/bash\n");
        sleep(30);
        &ssh_do($ssh, "export TERM=; export PROMPT_COMMAND=; export PS1='=# '\n");
        &ssh_do($ssh, "stty -echo ocrnl -onlcr\n");
        #$ssh->debug(2);
    }

    return $status;
}

sub ssh_do
{
    my $ssh = shift;
    my $str = shift;
    my $timeout = shift;

    die "ssh_do() called with '$ssh'\n" unless defined($str);
    $timeout = 60 unless defined($timeout);
    print "\nssh_do($timeout): $str\n";
    $ssh->send($str);
    my $res = $ssh->expect($timeout, -re, '^=# ');
    chomp($str);
    print "\nERROR: Timeout ($str($timeout)) waiting for prompt\n" unless defined($res);
    return $res;
}

sub system_do
{
   my $str = shift;

   print "\nsystem(\"$str\")\n\n";
   system($str);
}

my $num_args = $#ARGV +1;
if ($num_args != 3) {
  print "Usage: test_throughput.pl connnect_num request_num file\n";
  exit 1;
}
my $conn_num=shift;
my $req_num=shift;
my $req_file=shift;
my $client1_command="./ssl-ab-keepalive.sh 31 ".$conn_num." ".$req_num." TLS1 AES128-SHA  192.168.2.1 1 ".$req_file." 443 >/tmp/client.log &\n";
my $client2_command="./ssl-ab-keepalive.sh 31 ".$conn_num." ".$req_num." TLS1 AES128-SHA  192.168.4.1 1 ".$req_file." 443 >/tmp/client.log &\n";
print "Command1:$client1_command\n";
print "Command2:$client2_command\n";
my $ssh_client1 = new Expect;
my $ssh_client2 = new Expect;
my $port = 22;
ssh_connect($ssh_client1, "qat-server-130", "tester") =~ /success/ or die "\nqat-server-130: Cannot connect CRB, exiting\n";
ssh_connect($ssh_client2, "qat-server-128", "tester") =~ /success/ or die "\nqat-server-128: Cannot connect CRB, exiting\n";
ssh_do($ssh_client1,"cd /home/qat/git_home/tool/isg_cid-nginx-tools/tools/throughput\n");
ssh_do($ssh_client2,"cd /home/qat/git_home/tool/isg_cid-nginx-tools/tools/throughput\n");
#ssh_do($ssh_client1,"./ssl-ab-keepalive.sh 31 5 5000 TLS1 AES128-SHA  192.168.2.1 1 1m 443 >/tmp/client.log &\n");
ssh_do($ssh_client1,$client1_command);
#ssh_do($ssh_client2,"./ssl-ab-keepalive.sh 31 5 5000 TLS1 AES128-SHA  192.168.4.1 1 1m 443 >/tmp/client.log &\n");
ssh_do($ssh_client2,$client2_command);
sleep 120;
ssh_do($ssh_client1,"tail -n 1 /tmp/client.log |cut -d\" \" -f 1\n");
ssh_do($ssh_client2,"tail -n 1 /tmp/client.log |cut -d\" \" -f 1\n");
my $client1_val = $ssh_client1->before();
my $client2_val = $ssh_client2->before();
my $total = $client1_val + $client2_val;
print "the client1 :$client1_val \n the client2 :$client2_val \n the total :$total\n";
$ssh_client1->hard_close();
$ssh_client2->hard_close();

exit 0;
