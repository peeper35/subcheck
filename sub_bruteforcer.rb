#!/usr/bin/env ruby
require 'thread/pool'
require 'open-uri'
require 'rest-client'

tpool = Thread.pool(5)

class String

def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def bold;           "\e[1m#{self}\e[22m" end

end

  arr = Array.new
  arg0 = ARGV[0]
  base = ARGV[1]
  word = ARGV[3]

if arg0 == '-d'
  if  base.nil?
      puts "\n"
      puts "Usage: ruby sub_bruteforcer.rb -d <example.com>".bold.red
      puts "Usage for custom wordlist: ruby sub_bruteforcer.rb -d <example.com> -w <wordlist>".bold
      exit
   end
else
      puts "\n"
      puts "Usage: ruby sub_bruteforcer.rb -d <example.com>".bold.red
      puts "Usage for custom wordlist: ruby sub_bruteforcer.rb -d <example.com> -w <wordlist>".bold
      exit
end
   
   if word.nil?
       puts "\n"
       puts "Using default wordlist.".brown
       puts "\n"
       sleep(1)
   end

 
 puts "\n"
 puts"--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---".blue
 puts "Generating Subdomain Wordlist...".blue
 puts"--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---".blue

   if word.nil?
       File.open("wordlist.txt").each_line {|s| arr << s}
       arr.map! { |each| each.gsub(/\n/, '') }
   else 
       File.open("#{word}").each_line {|s| arr << s}
       arr.map! { |each| each.gsub(/\n/, '') }
   end
 
 sleep 2
 puts "\n"
 puts "Done!".bold.green
 puts "\n"

 sleep(3)

 puts "\n"
 puts "--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---".blue
 puts "Bruteforcing Subdomains...".blue
 puts "--- --- --- --- --- --- --- --- --- --- --- --- --- --- ---".blue
 puts "\n"

 sleep(2)
  
    arr.each do |sub|
     tpool.process do
     sleep 1
      begin
        check = RestClient.get("http://" + sub.to_s + "." + base)
         if check.code == 200 || check.code == 302 || check.code == 301 || check.code == 404 || check.code == 403 
           puts " Subdomain Found =>".bold + " " + "#{sub.to_s}"+"."+"#{base}"
         end 
     rescue
      next
     end
     end
     end

tpool.shutdown
    
 sleep(2)
