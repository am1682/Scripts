#1 Fix:Importing this file with $fetch $filename will result in $1=$file. In this case, create variable. ( && ($1 != $file) , || ($1 = $file))
#1 Limitation:version of this file must be manually updated by $ver Version_Control n
#2 Fix:Importing this file with $im $globalname will result in $1=$globalname. In this case, create variable. ( && ($1 != $globalname) , || ($1 = $globalname))
##/import thisfile.rsc will create a global variable $globalname
##$globalname $1 return&put value for variable name $1
##$globalname $1 $2 set value of $1 as $2
##$globalname $1 REMOVE will remove variable $1 altogether.
:global func;:global var;
:if (([:len $func] = 0) || ([:len $var] = 0)) do={:global im;$im func p=1 v=$v;$im var v=$v;};
:local file "var_ver.rsc";:local end;
:local dir [$func dir v=$v];:local timestamp [$func timestamp];
:local emailto "Version_Control<allros@163.com>";
:local globalname ver;
##$ver Auto-Gracemode_(prefix) r=1(Optional:retain or not)
:if (([:len $1] = 0)  || ($1 = $file)  || ($1 = $globalname)) do={
    [$func global $globalname v=$v]
    :if ($v > 0) do={:put "Global variable Ready: $globalname --$0";} 
    :set end 1;
};
:if (($1 = "print") || ($2 = "print")) do={
    /ip ipsec peer print brief where comment~"var_$globalname.rsc=" disabled=yes  
    :put "Print Completed:bye! --$globalname --$0";
    :set end 1;
};
:if ($2 = "REMOVE") do={
    :put "Remove version of $1 from system $globalname --$0"
    /ip ipsec peer remove [find name=$1 disabled=yes];
    :set end 1;
}
:if (([:len $2]= 0) && ([:len $1] > 0) && ($1 != $file) && ($1 != $globalname)) do={
    :do {
        :put "Display and return version of $1:$[/ip ipsec peer get [find name=$1 disabled=yes] address] $globalname --$0";
        :return [/ip ipsec peer get [find name=$1 disabled=yes] address];
    } on-error={
        :put "Initializing version of $1 as 0 $globalname --$0";
        /ip ipsec peer add name=$1 address=0 disabled=yes comment="var_$globalname.rsc=$1-$timestamp";
        :return 0;
    }
    :set end 1;
}
:if ($end = 1) do={:if ($v > 0) do={:put "Exiting --$globalname --$0";}} else={
    :do {
    :put "Change version of $1 from $[/ip ipsec peer get [find name=$1 disabled=yes] address] to $2 $globalname --$0"
    /ip ipsec peer set [find name=$1 disabled=yes] address=$2
    } on-error={
    :put "Creating version of $1 as $2 $globalname --$0"
    #/ip ipsec peer add name=$1 address=$2 disabled=yes comment="By-$globalname-$file";
    /ip ipsec peer add name=$1 address=$2 disabled=yes comment="var_$globalname.rsc=$1-$timestamp";
    }
    :put "Sending email to $emailto for this event. $globalname --$0"
    /tool e-mail send to=$emailto subject="$[/system identity get name]:$1 is now <Version $2>#Version_Control#" body="$[/system identity get name]:$1 is now <Version $2>#Version_Control#\r\n--Sent from $file"
}
$var ("$0-log") ("$0 $1 $2 $3 $4 $5") f=1 a=1 v=$v; 
##Code below does not work. Don't know why...
#:if ($r=1) do={
#    :put "Retained: global variable $globalname"
#} else={
#    :put "Removed:global variable $globalname."; :execute ":global $globalname (/)";
#};

##name must differ from $file to avoid conflit with another rule.
