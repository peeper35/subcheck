#!/usr/bin/env ruby
require 'open-uri'
require 'rest-client'

   arr = []
   arg = ARGV

     for a in arg  
      base = a
     end

if base.nil?
   puts "\nUsage:\n"
   puts "ruby sub_bruteforcer.rb <example.com>"
   puts "\n"
   exit
end

puts "\n"
puts"--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---"
puts "Generating Subdomain Wordlist.."
puts"--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---"

    get_subs = open("https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1mil-110000.txt").read
    
    get_subs.each_line do |s|
     arr << s
    end

   arr.map! { |each| each.gsub(/\n/, '') }

puts "\nCompleted."
sleep(3)
puts "\n"
puts "--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---"
puts "Bruteforcing Subdomains.."
puts "--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---\n\n"
sleep(2)
 
    arr.each do |sub|
      begin
        check = RestClient.get("http://" + sub.to_s + "." + base)
         if check.code == 200 || check.code == 302 || check.code == 301 
           puts "Subdomain Found := #{sub.to_s}"+"#{base}"
         end 
     rescue
      next
     end
    end 


puts "\nCompleted."
sleep(4)
