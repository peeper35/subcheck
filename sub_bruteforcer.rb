#!/usr/bin/env ruby
require 'thread/pool'
require 'open-uri'
require 'rest-client'

class String
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def bold;           "\e[1m#{self}\e[22m" end
end

def check(domain, wordfile)
  if domain.nil?
      puts "\nUsage: ruby sub_bruteforcer.rb -d <example.com>".red
      puts "Usage for custom wordlist: ruby sub_bruteforcer.rb -d <example.com> -w <wordlist>"
      exit
  end

  if wordfile.nil?
       puts "\n[+] Using default wordlist.".brown
       sleep 1
   end
end

def genwordlist(wordfile)
	wordlistarr = Array.new

	if wordfile.nil?
       File.open("wordlist.txt").each_line {|subd| wordlistarr << subd}
       wordlistarr.map! { |each| each.gsub(/\n/, '') }
   else 
       File.open("#{wordfile}").each_line {|subd| wordlistarr << subd}
       wordlistarr.map! { |each| each.gsub(/\n/, '') }
   end

   return wordlistarr
end

def startbruteforce(domain)
	tpool = Thread.pool(5)
	puts "\nGenerating Subdomain Wordlist.\n".blue
	sleep 2
	puts "Bruteforcing Now.\n".blue
	genwordlist(words = ARGV[3]).each do |subd|
		tpool.process do
			sleep 1
			begin
				check = RestClient.get("http://"+subd.to_s+"."+domain.to_s)
				if check.code == 200 || check.code == 302 || check.code == 301 || check.code == 404 || check.code == 403
					puts "Subdomain Found ->"+" "+subd.to_s+"."+domain.to_s
				end 
			rescue 
			next
			end
		end
	end
	tpool.shutdown
end

check(ARGV[1], ARGV[3])
startbruteforce(ARGV[1])
