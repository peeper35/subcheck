#!/usr/bin/env ruby
require 'concurrent'
require 'open-uri'
require 'rest-client'

class String

def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def bold;           "\e[1m#{self}\e[22m" end

end

  arr = Array.new
  base = ARGV[1]
  word = ARGV[3]

   if  base.nil?
      puts "\n"
      puts "Usage: ruby sub_bruteforcer.rb -u <example.com>".bold.red
      puts "Usage for custom wordlist: ruby sub_bruteforcer.rb -u <example.com> -w <wordlist>".bold
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

 
pool = Concurrent::ThreadPoolExecutor.new(
   min_threads: 3, 
   max_threads: 10, 
   max_queue: 100,
   fallback_policy: :caller_runs 
)
  
    arr.each do |sub|
     pool.post do
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

 sleep(2)
