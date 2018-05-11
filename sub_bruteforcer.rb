#!/usr/bin/env ruby
require 'thread/pool'
require 'open-uri'
require 'rest-client'

$tpool = Thread.pool(5)

class String
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def bold;           "\e[1m#{self}\e[22m" end
end

def check(d, w)
  if d.nil?
      puts "\nUsage: ruby sub_bruteforcer.rb -d <example.com>".bold.red
      puts "Usage for custom wordlist: ruby sub_bruteforcer.rb -d <example.com> -w <wordlist>".bold
      exit
  end

  if w.nil?
       puts "\nUsing default wordlist.".brown
   end
end

def genwordlist(w)
	wordlistarr = Array.new

	if w.nil?
       File.open("wordlist.txt").each_line {|s| wordlistarr << s}
       wordlistarr.map! { |each| each.gsub(/\n/, '') }
   else 
       File.open("#{w}").each_line {|s| wordlistarr << s}
       wordlistarr.map! { |each| each.gsub(/\n/, '') }
   end

   return wordlistarr
end

def startbruteforce(dom)
	puts "\nGenerating Subdomain Wordlist.\n".blue
	sleep 2
	puts "Bruteforcing Now.\n".blue
	genwordlist(words = ARGV[3]).each do |sub|
		$tpool.process do
			cont = 0
			sleep 1
			begin
				check = RestClient.get("http://" + sub.to_s + "." + dom.to_s)
				if check.code == 200 || check.code == 302 || check.code == 301 || check.code == 404 || check.code == 403 
					puts " Subdomain Found =>".bold + " " + "#{sub.to_s}"+"."+dom.to_s
				end 
			rescue 
			next
			end
		end
	end
end

check(domain = ARGV[1], wordloc = ARGV[3])
genwordlist(words = ARGV[3])
startbruteforce(domain = ARGV[1])
$tpool.shutdown
