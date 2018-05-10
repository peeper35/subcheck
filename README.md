# sub_bruteforcer

A simple ruby script for bruteforcing subdomains. 
This script uses a wordlist from the ` SecLists ` repo and then it checks for all the available subdomains.

# Multi Threaded

The script has thread pooling, so it is not going to take much time to bruteforce all the subdomains.

## Thanks to SecLists and its creators

Thanks to SecLists for such an awesome wordlist, I've used one of the wordlist under **/Discovery/DNS/** as the default wordlist here.

**Preferred Ruby Version** : ` ruby 2.4.* `

**Required Gems:**
```
thread/pool

open-uri

rest-client
```
## Usage

``` 
$ ruby sub_bruteforcer.rb -d <example.com>
```
**Custom wordlist:**
```
$ ruby sub_bruteforcer.rb -d <example.com> -w <wordlist>
```

*Without angle brackets*


