#!/usr/bin/perl
printf("************************************\n");
printf("       Test the If ...else...\n");
printf("************************************\n");
$con1=2;
$con2=3;
printf("\$con1=$con1 , \$con2=$con2\n");
if($con2 > $con1)
{
 printf("The \$con2 is bigger than \$con1\n");
}


if($con1 > $con2)
{
 printf("The \$con2 is bigger than \$con1\n");
}else{
 printf("The \$con1 is smaller than \$con2\n");
}



exit 0;
