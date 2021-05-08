##Redial until IP is in predefined range.
:local input do={:put $1;:return};
:local name [$input "Which FTTH:"];
#:local name FTTH;
:local range 58.32.0.0/16;
:local ipaddr;
:local redial 1;
    do {
        /interface pppoe-client enable $name; :put "$name Enabled";:delay 5s;
        #Make sure connection is active.
        :do {
          :set ipaddr 0.0.0.0;
          do {
          :set ipaddr [/ip address get [/ip address find interface=$name] address];
          } on-error={:put "$name not connected. Wait for 2s..."; :delay 2s;};
        } while=( $ipaddr = 0.0.0.0 );
        :if (!($ipaddr in $range)) do={
          :put "IP address $ipaddr not in $range.Redial x $redial..."
          /interface pppoe-client disable $name; :put "$name Disabled, wait for 5s...";
          :set redial ($redial+1);:delay 5s;
        }
    } while=(! ($ipaddr in $range) )
    :put "Success:IP address $ipaddr in $range after $redial attempt(s)."
};
