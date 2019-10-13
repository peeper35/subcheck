# subcheck.rb

A simple ruby script for bruteforcing subdomains. 
This script uses a wordlist from the ` SecLists ` repo and then it checks for all the available subdomains.

## Thanks to SecLists and its creators

Thanks to SecLists for such an awesome wordlist, I've used one of the wordlist under **/Discovery/DNS/** as the default wordlist here.

**Required Gems:**
```
optparse

resolv

socket

timeout
```
## Usage

``` 
$ ruby subcheck.rb -d <target domain>
```
**Custom wordlist:**
```
$ ruby subcheck.rb -d <target domain> -w <wordlist>
```

**Saving output to file:**
```
$ ruby subcheck.rb -d <target domain> -o <outfile>
```

*Without angle brackets*


