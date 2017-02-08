#!/usr/bin/perl
#define the globale variable
my $KPT_ROOT = $ENV{KPT_ROOT};
my $LOG_FILE = "ITP.log";
my $SHIM_AUTO_DIR = "";
my $CONF_FILE = "";
my $TEST_TYPE = "";
my $RECIPIENTS = "";
my $SUBJECTS ="KPT_UTILS_ITP";
my $green = "#80f030";
my $red = "#ff0000";
my $yellow = "#f0f030";

my @ALL_TEST_DETAILS = ();
my %TEST_EXEC_LIST;
my $INSTALL_SCRIPT = "";

#Configuration Parameter:

#DEFINITION
#TEST LIST TYPE
my @TEST_LIST= ("ALL","AGENT","CLIENT","WPK");

#TEST CASE TYPE
my $TEST_COMPONENT = 0;
my $TEST_ID = 1;
my $TEST_DESC = 2;
my $TEST_SCRIPT = 3;
my $TEST_ERROR_PATTERN = 4;
my $TEST_SUCCESS_PATTERN = 5;
my $TEST_LOG_FILE = 6;
my $TEST_PARAMETER = 7;

main();

sub mlog
{
    ($logStr) = @_;
     system("date \+\"%d-%m-%Y %T: $logStr\" >> $LOG_FILE");
     print "$logStr\n";
}

sub stripBlank
{
    $string = shift;
    chomp($string);
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

sub printUsage
{
    print("Usage: perl kpt_utils_itp.pl <SHIM_AUTO_DIR> <CONF_FILE> <TYPE OF TESTING>\n\n");
    print("AUTO_DIR      : Path where all the scripts are placed\n\n");
    print("CONF_FILE     : Configuration File appended with path\n\n");
    print("TYPE OF TEST  : On Selecting Operation TYPE, This argument is mandatory. Eg: ALL, CLIENT, AGENT, WPK. ");
    print("Eg: perl  kpt_utils_itp.pl /home/automation/  kpt_utils.conf ALL\n\n");
    exit;
}

sub validateArgument
{
     if(($#ARGV+1)!= 3 )
    {
        print "Number of expected argument is not valid!!!!!\n\n";
        printUsage();
        exit;
    }
    $SHIM_AUTO_DIR=$ARGV[0];
    chomp( $SHIM_AUTO_DIR );
    if( !(-d $SHIM_AUTO_DIR ))
    {
        print "ERROR: SHIM DIRECTORY $SHIM_AUTO_DIR doesn't exists\n";
        printUsage();
        exit;
    }
    $CONF_FILE=$ARGV[1];
    if(!(-e $CONF_FILE) || (-z $CONF_FILE))
    {
        print "ERROR: Configuration File $CONF_FILE doesn't exists or empty!!!!!\n\n";
        exit;
    }
    $TEST_TYPE=$ARGV[2];
    my $type_flag=0;
    foreach $type(@TEST_LIST)
    {
     if($TEST_TYPE eq $type){ $type_flag=1; last; }
    }
    if(!$type_flag)
    {
        print "ERROR: Test Type $TEST_TYPE doesn't exists or empty!!!!!\n\n";
        exit;
    }
 }

sub readConfig
{
    mlog("LOG: Entering readConfig to load details from $CONF_FILE");
    open( CONF_FP, " < $CONF_FILE");
    my @testDetailArr = ();
    my $testTypeName = "";
    my $testTypeValue = "";

    while(defined($line=<CONF_FP>))
    {
        $line = stripBlank($line);
        if( $line =~ /^#/ || length($line) == 0)
        {
            next;
        }
        if( $line =~ /\[GENERAL\]/)
        {
            next;
        }
        if( $line =~ /\[\/GENERAL\]/)
        {
            next;
        }
        if( $line =~ /\[TEST_CASE\]/)
        {
            next;
        }
        if( $line =~ /\[\/TEST_CASE\]/)
        {
            $ALL_TEST_DETAILS[$testDetailArr[$TEST_ID]]=[@testDetailArr];
            undef @testDetailArr;
            next;
        }
        if( $line =~ /\[TEST_TYPE\]/)
        {
            next;
        }
        if( $line =~ /\[\/TEST_TYPE\]/)
        {
            $TEST_EXEC_LIST{$testTypeName}=$testTypeValue;
            undef $testTypeName;
            undef $testTypeValue;
            next;
        }

        ($label, $value) = split("=",$line);
        $label = stripBlank($label);
        $value = stripBlank($value);

        if($label eq "TEST_COMPONENT") { $testDetailArr[$TEST_NAME] = $value }
        elsif($label eq "TEST_ID") { $testDetailArr[$TEST_ID] = $value }
        elsif($label eq "TEST_DESC") { $testDetailArr[$TEST_DESC] = $value }
        elsif($label eq "TEST_SCRIPT") { $testDetailArr[$TEST_SCRIPT] = $value }
        elsif($label eq "ERROR_PATTERN") { $testDetailArr[$TEST_ERROR_PATTERN] = uc($value) }
        elsif($label eq "SUCCESS_PATTERN") { $testDetailArr[$TEST_SUCCESS_PATTERN] = uc($value) }
        elsif($label eq "LOG_FILENAME") { $testDetailArr[$TEST_LOG_FILE] = $value }
        elsif($label eq "TEST_LIST_NAME") { $testTypeName = $value }
        elsif($label eq "TEST_LIST") { $testTypeValue = $value;}
        elsif($label eq "INSTALL_SCRIPT") { $INSTALL_SCRIPT = $value;}
        elsif($label eq "RECIPIENTS") { $RECIPIENTS= $value;}
        else { next; }
    }
    mlog("LOG: Exiting readConfig after loading details from $CONF_FILE");
}

sub validateSHIMS
{
    mlog("LOG: Starting the test");
    @testIdArr = split( / /, $TEST_EXEC_LIST{$TEST_TYPE});
    $autoTestScript = "$SHIM_AUTO_DIR/${SHIM_NAME}_autoTest.sh";
    foreach $testId(@testIdArr)
    {
        $tmpStr = "";
        $tmpStr = "$SHIM_AUTO_DIR/" . $ALL_TEST_DETAILS[$testId][$TEST_SCRIPT] ." 2>\&1|";
        $tmpStr .= "tee " . $ALL_TEST_DETAILS[$testId][$TEST_LOG_FILE]. " 2>\&1 > /dev/null ";
        #  interface for test case
        system($tmpStr);
        mlog($tmpStr);
        mlog("LOG: Including TEST " . $ALL_TEST_DETAILS[$testId][$TEST_NAME]);
    }
    mlog("LOG: Finishing the test");
}

sub generateResult
{
    mlog("LOG: Starting the generateResult");
    @testIdArr = split( / /, $TEST_EXEC_LIST{$TEST_TYPE});
    open(HTMLFILE, ">email.html") or die "\nCannot open email.html\n";
    print HTMLFILE "MIME-Version: 1.0\n";
    print HTMLFILE "Content-type: text/html; charset=iso-8859-1\n";
    print HTMLFILE "Subject: $SUBJECTS\n";
    print HTMLFILE "To: $RECIPIENTS\n";
    print HTMLFILE "<html><style>\n";
    print HTMLFILE "h2{font-family: Verdana, Arial, sans-serif; font-size: 14; color: #000099; }\n";
    print HTMLFILE "h3.normal{font-family: Verdana, Arial, sans-serif; font-size: 12; color: blue; }\n";
    print HTMLFILE "h3.warning {font-family: Verdana, Arial, sans-serif; font-size: 12; color: orange; }\n";
    print HTMLFILE "table{font-family: Verdana, Arial, sans-serif; font-size: 12; }\n";
    print HTMLFILE "table td { white-space: nowrap; }\n";
    print HTMLFILE "</style>\n";
    print HTMLFILE "<center><h2><font color=#0040ff>Results Summary</font></h2></center>\n";
    print HTMLFILE "<center><table border=1 cellpadding=0><tr><td bgcolor=#000000>\n";
    print HTMLFILE "<table border=1 cellspacing=1 cellpadding=2>\n";
    print HTMLFILE "<tr><th bgcolor=$green width=15% align=center>Test Id</th>\n";
    print HTMLFILE "<th bgcolor=$green width=20% align=center>Test Name</th>\n";
    print HTMLFILE "<th bgcolor=$green width=15% align=center>Reasult</th>\n";
    print HTMLFILE "<th bgcolor=$green width=50% align=center>Comment</th></tr>\n";
    foreach $testId(@testIdArr)
    {
        $logStr = "$ALL_TEST_DETAILS[$testId][$TEST_LOG_FILE]";
        $idStr = "$ALL_TEST_DETAILS[$testId][$TEST_ID]";
        $nameStr = "$ALL_TEST_DETAILS[$testId][$TEST_NAME]";
        print HTMLFILE "<tr><td bgcolor=$yellow align=center>$idStr<br></td>\n";
        print HTMLFILE "<td bgcolor=$yellow align=center>$nameStr<br></td>\n";
        open(LOGFILE, "<$SHIM_AUTO_DIR/$logStr");
        while(defined($line=<LOGFILE>))
    	{
    	   $line = stripBlank($line);
           ($label, $value) = split("=",$line);
           $label = stripBlank($label);
           $value = stripBlank($value);
           if($label eq "$nameStr"."_REASULT")
           {
             if(uc($value) eq "$ALL_TEST_DETAILS[$testId][$TEST_SUCCESS_PATTERN]")
             {
               print HTMLFILE "<td bgcolor=$yellow align=center>$value<br></td>\n";
               print HTMLFILE "<td bgcolor=$yellow align=center>NONE<br></td></tr>\n";
             }else
             {
               print HTMLFILE "<td bgcolor=$red align=center>$value<br></td>\n";
               print HTMLFILE "<td bgcolor=$red align=center>$ALL_TEST_DETAILS[$testId][$TEST_LOG_FILE]<br></td></tr>\n";
             }
           }
           else { next; }
        }
    }
    print HTMLFILE "</table></td></tr></table></center></html>\n";
    close(HTMLFILE);
    system("cat $SHIM_AUTO_DIR/email.html | /usr/sbin/sendmail -B8BITMIME -- $RECIPIENTS");
    mlog("LOG: Finishing the generateResult");
}

sub main
{
    mlog("LOG: ******ENTERING AUTOVALIDATE******");

    #Validate the Arguments Passed
     validateArgument();

    #read Details from Configuration File
     readConfig();

    #Start Testing
    validateSHIMS();

    #Generate Result
    generateResult();
}
