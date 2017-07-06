#!/usr/bin/perl
printf("******************************************\n");
printf("          Welcome Perl World!\n");
printf("******************************************\n");

printf("******************************************\n");
printf("          Testing the specil value\n");
printf("******************************************\n");
printf("The script name:$0\n");
if ($#ARGV==-1){
  printf("The script test the varable\n");
  exit 0;
}
printf("The argrument value:@ARGV\n");
printf("The argrument number(the real val=\$#ARGV +1):$#ARGV\n");
printf("Output the argrument:\n");
my $num=0;
foreach $value (@ARGV)
{
printf("$num:$value\n");
$num++;
};

printf("******************************************\n");
printf("          Testing the string value\n");
printf("******************************************\n");
$str1="Hello world";
$str2="Perl";
printf("\$str1:$str1   ,   \$str2:$str2\n");
printf("The symbol: lt , gt , eq , ne , le , ge , cmp  .=  0-9,A-Z,a-z\n");
printf("Connect the  string                  :\$str1\.\$str2>>>>>$str1.$str2!\n");
$str3=$str1 x 2;
printf("Repeat the  string(caution the space) \$str1 x num>>>>> $str3 = $str1 x 2 !\n");
$str4=(($str1 cmp $str2)<0)? "True" : "Fasle";
$str5=($str1 cmp $str2);
printf("Compare the  string                  :\$str1 cmp \$str2>>>>>$str1 cmp $str2=$str5 $str4!\n");
$str4=(($str2 cmp $str1)<0)? "True": "Fasle";
$str5=($str2 cmp $str1);
printf("Compare the  string                  :\$str2 cmp \$str1>>>>>$str2 cmp $str1=$str5 $str4!\n");

printf("******************************************\n");
printf("          Testing the number value\n");
printf("******************************************\n");
$num1=10;
$num2=2;
printf("\$num1:$num1  ,    \$num2:$num2\n");
printf("The symbol:+ - * / % ** - ++ -- += -= *= /= %= **=\n");
printf("The symbol:< <= > >= == <=> !=\n");
$num3=$num1+$num2;
$symbol="+";
printf("Add     :\$num1$symbol\$num2=\$num3 $num1$symbol$num2=$num3\n"); 
$num3=$num1-$num2;
$symbol="-";
printf("Sub     :\$num1$symbol\$num2=\$num3 $num1$symbol$num2=$num3\n"); 
$num3=$num1*$num2;
$symbol="*";
printf("Muti    :\$num1$symbol\$num2=\$num3 $num1$symbol$num2=$num3\n"); 
$num3=$num1/$num2;
$symbol="/";
printf("Divisi  :\$num1$symbol\$num2=\$num3 $num1$symbol$num2=$num3\n"); 
$num3=$num1**$num2;
$symbol="**";
printf("Power   :\$num1$symbol\$num2=\$num3 $num1$symbol$num2=$num3\n"); 

printf("******************************************\n");
printf("          Testing the other symbols\n");
printf("******************************************\n");
printf("Logical symbol: &&(and) ||(or) !(not) xor\n");
printf("Bit symbol    : & | ~ ^ <<   >>  &= |= ^=\n");
printf("Condition symbol: ?  :  ;\n");

printf("******************************************\n");
printf("          Testing the array\n");
printf("******************************************\n");
printf("       The array value is number\n");
@array1=(1,2,3,4,5,6);
printf("\@array1:@array1\n");
printf("\@array1:\n");
foreach(@array1){
printf("$_ ");
}
printf("\n");
printf("The first value \$array1[0]:$array1[0] \@array1:@array1[0]\n");
printf("       The array value is string\n");
@array1="abcdefg";
printf("\@array1:@array1\n");
printf("\@array1:\n");
foreach(@array1){
printf("$_ ");
}
printf("\n");
printf("The first value \$array1[0]:$array1[0] \@array1:@array1[0]\n");
printf("       The array value is char\n");
@array1=(a,b,c,d,e,f,g);
printf("\@array1:@array1\n");
printf("\@array1:\n");
foreach(@array1){
printf("$_ ");
}
printf("\n");
printf("The first value \$array1[0]:$array1[0] \@array1:@array1[0]\n");

$length=@array1;
printf("The length of \@array1:$length\n");


printf("The list:\n");
printf("(1..10):");
foreach (1..10)
{
 printf("$_ ");
};
printf("\n");
printf("(1.1..10.2):");
foreach (1.1..10.2)
{
 printf("$_ ");
};
printf("\n");
printf("(10.1..1.1):");
foreach (10.1..1.1)
{
 printf("$_ ");
};
printf("\n");
printf("(\"aaa\"..\"aad\"):");
foreach ("aaa".."aad")
{
 printf("$_ ");
};
printf("\n");
$fred="Fred";
printf(("Hello,".$fred."!\n") x 2 );
print(("Hello,".$fred."!\n") );
print(("Hello,".$fred."!\n") x 2 );
printf("End the list\n");

printf("The sub array:\n");
@array1=(1,2,3,4,5,6);
printf("\@array1:@array1\n");
@subarray=@array1[2..4];
printf("\@subarray=\@array1[2..4]:@subarray\n");
@array1[2..4]=@array1[4..2];
printf("\@array1[2..4]=\@array1[4..2]:@array1\n");
@array1=(1,2,3,4,5,6);
@array1[2..4]=@array1[4..5];
printf("\@array1[2..3]=\@array1[4..5]:@array1\n");

printf("The string fuction library:\n");
@array1=("This","is","a","test");
@array2=sort(@array1);
printf("sort:\@array1:@array1 \@array2:@array2\n");
@array2=reverse(@array1);
printf("reverse:\@array1:@aaray1 \@array2:@array2\n");
@array1=("This","is","a");
$joinstring=join("==",@array1,"animal");
printf("join: \@array1:@array1 and annimal:$joinstring\n");
@array1=split("==",$joinstring);
printf("split: @array1\n");


printf("******************************************\n");
printf("          Testing the hash\n");
printf("******************************************\n");
%hash1=(a=>1,b=>2,c=>3);
printf("\%hash1:%hash1\n");
printf("\%hash1: a=>$hash1{a} ,b=>$hash1{b} ,c=>$hash1{c}\n");
while(my( $k, $v)= each %hash1){
 printf("$k---->$v\n");
};
printf("add the item: d=>4\n");
$hash1{d}=4;
while(my( $k, $v)= each %hash1){
 printf("$k---->$v\n");
};
printf("delete the item: a=>1\n");
delete $hash1{a};
while(my( $k, $v)= each %hash1){
 printf("$k---->$v\n");
};
printf("clear the item: a=>1 b=>2 c=>3 d=>4\n");
undef %hash1;
while(my( $k, $v)= each %hash1){
 printf("$k---->$v\n");
};
%hash1=(a=>1,b=>2,c=>3,d=>4);
while(my( $k, $v)= each %hash1){
 printf("$k---->$v\n");
};
@key= keys %hash1;
printf("\%hash1's keys:@key\n");
$num=keys %hash1;
printf("\%hash1' size:$num\n");
printf("*****************************************\n");
printf("           End the Perl !\n");
printf("*****************************************\n");
exit 0;
