### /im var_approve.rsc; $approve Global-Seven MAC/Toronto 29; $approve Global-Seven REMOVE;$approve (Global-Seven/MAC) print;$approve to refresh;
:global func; :global var;
:if (([:len $func] = 0) || ([:len $var] = 0)) do={:global im;$im func p=1 v=$v;$im var v=$v;};
:local globalname approve;
:local dir [$func dir];:local timestamp [$func timestamp];
:local end;
:local macaddr $2;
:do {:set macaddr [/ip hotspot active get [find user=$2] mac-address]} on-error={:if ($v > 0) do={:put "Please confirm MAC address: $2";}};
:local ipaddr ([$var SubnetLAN v=$v] . "$3");
:if ($v > 0) do={:put "IP Address Proposed: $ipaddr --$globalname --$0";}
:if (([:len $1] = 0)  || ($1 = "var_$globalname.rsc")  || ($1 = $globalname)) do={
    [$func global $globalname v=$v]
    :if ($v > 0) do={:put "Global variable Ready: $globalname --$0";}
    :set end 1;
}
:if (($1 = "print") || ($2 = "print")) do={
    /ip dhcp-server lease print terse where comment~"$1";
    /ip hotspot ip-binding print terse  where comment~"$1"; 
    :put "Print Completed:bye! --$globalname --$0";
    :set end 1;
};
:if ($2 = "REMOVE") do={
    /ip dhcp-server lease print terse where comment~"$1";
    /ip dhcp-server lease remove [find comment~"$1"];
    /ip hotspot ip-binding print terse where comment~"$1"; 
    /ip hotspot ip-binding remove [find comment~"$1"];
    :put "Removed: all entries above with $1 --$globalname --$0"
    :set end 1;
};
:if ($end = 1) do={:if ($v > 0) do={:put "Exiting $globalname --$globalname --$0";}} else={
    ###add on-error if ip is not entered. in that case do not set static IP
    /ip dhcp-server lease print where address=$ipaddr
    /ip dhcp-server lease set [find address=$ipaddr] disabled=yes
    /ip hotspot host print where mac-address=$macaddr;
    /ip hotspot host remove [find mac-address=$macaddr];
    /ip dhcp-server lease print where active-mac-address=$macaddr;
    /ip dhcp-server lease remove [find active-mac-address=$macaddr];
    if ($v > 0) do={:put "REMOVED: All above entries";}
    do {/ip dhcp-server lease add mac-address=$macaddr address=$ipaddr server=SubnetGuest comment="var_$globalname.rsc-$1=$3-$timestamp";:put "Static IP $ipaddr Assigned: $1 --$globalname --$0"} on-error={:put "Failed when adding dhcp-server lease:$1 --$globalname --$0"};
    do {/ip hotspot ip-binding add type=bypassed mac-address=$macaddr comment="var_$globalname.rsc-$1=$3-$timestamp";:put "Hotspot Bypassed: $1 --$globalname --$0"} on-error={:put "Failed when adding hotspot ip-binding:$1 --$globalname --$0"};
};
:global var;$var ("$0-log") ("$0 $1 $2 $3 $4 $5") f=1 a=1 v=$v;

if ($v > 0) do={:put "End of file $globalname --$globalname --$0";}