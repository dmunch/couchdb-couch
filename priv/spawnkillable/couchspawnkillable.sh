#! /bin/sh -e

# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

# The purpose of this script is to echo an OS specific command before launching
# the actual process. This provides a way for Erlang to hard-kill its external
# processes.

killCmd="kill -9 $$"
Cmd=$*

if [ "$1" == "--bert" ]; 
  then
    #send packet with 4 bytes length header
    
    #get $killCmd length and format it as 4 digit hex string
    hexLength=$(printf "%08X" ${#killCmd})
    
    #extract the 4 hex digits
    d1=${hexLength:0:2}
    d2=${hexLength:2:2}
    d3=${hexLength:4:2}
    d4=${hexLength:6:2}
   
    #print the killCmd preceding the 4 bytes 
    printf "\x$d1\x$d2\x$d3\x$d4%s" "$killCmd"

    #strip the first command line argument
    Cmd=${*:2}
  else
    echo $killCmd 
fi

exec $Cmd
