### /im var_fix.rsc; $fix github.com (rem=github) (direct); $fix github.com REMOVE;$fix (ALL/google.com/V2EX) print; $fix ALL REMOVE;$fix to refresh;
##:global GMadd [:parse [/file get "2021Gracemode-Add.rsc" content]]
#add api.github.com
:global im; $im func p=1 v=$v; :global func;
:local globalname fix;
:local disab no;
:local dir [$func dir];
:local timestamp [$func timestamp];
:local remark $rem;:local end;
:local key "-";:if (($1 != "ALL") && ($1 != "print")) do={:set key $1};
:if (([:len $1] = 0)  || ($1 = "var_$globalname.rsc")  || ($1 = $globalname)) do={
    [$func global $globalname v=$v]
    :if ($v > 0) do={:put "Global variable Ready: $globalname --$0";} 
    :set end 1;
} else={
    :if ($2 = "direct") do={:set disab "yes";};
#    :if ([:len $2] > 0) do=
     :if (($1 = "print") || ($2 = "print")) do={
        /ip dns static print terse where comment~"var_$globalname.rsc-" comment~"$remark=" comment~"$key";
        /ip route rule print terse where comment~"var_$globalname.rsc-" comment~"$remark=" comment~"$key";
        :put "Print Completed:bye! --$globalname --$0";
        :set end 1;
     };
     :if ($2 = "REMOVE") do={
        /ip dns static print terse where comment~"var_$globalname.rsc-" comment~"$remark=" comment~"$key";
        /ip dns static remove [find comment~"var_$globalname.rsc-" comment~"$remark=" comment~"$key"];
        /ip route rule print terse where comment~"var_$globalname.rsc-" comment~"$remark=" comment~"$key";
        /ip route rule remove [find comment~"var_$globalname.rsc-" comment~"$remark=" comment~"$key"];
        :put "Removed: all entries above with $1 --$0"
        :set end 1;
    }
    :if ($end = 1) do={:if ($v > 0) do={:put "Exiting --$globalname --$0";}} else={
        :local svrip "$[:resolve $1 server=8.8.8.8]"; if ($v > 1) do={:put "$1 resolved as $svrip --$0";}
        do {/ip dns static add name=$1 address=$svrip comment="var_$globalname.rsc-$remark=$1-$svrip-$timestamp";} on-error={:put "Failed when adding dns static:$1 --$0"};
        :put "$1 resolved as: $svrip. Direct connection:$disab --$0";
        do {/ip route rule add dst-address=$svrip table=LAN-Auto comment="var_$globalname.rsc-$remark=$1-$svrip-$timestamp" disabled=$disab} on-error={:put "Failed when adding route rule:$1 --$0"};
    };
    ##Use execute to silent output text.
    $im var v=$v;:global var;$var ("$0-log") ("$0 $1 $2 $3 $4 $5 rem=$rem") f=1 a=1 v=$v;
}
if ($v > 0) do={:put "End of file $globalname --$0";}