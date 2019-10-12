#!/usr/bin/env ruby
require 'optparse'
require 'resolv'
require 'socket'
require 'timeout'

ARGV << '-h' if ARGV.empty?
ARGV << '-h' if !ARGV.include?('-d')

options = {}

if !ARGV.include?('-w')
  puts "Using default wordlist \n\n"
  options[:words] = File.readlines('wordlist.txt').map(&:chomp)
end


OptionParser.new do |opts|
  opts.banner = "Usage: ruby sub_bruteforcer.rb -d <target domain> // optional -w <wordlist>"

  opts.on("-d", "--domain=<domain>", "Target Domain") do |domain|
    options[:domain] = domain
  end

  opts.on("-w", "--wordlist=<wordlist>", "Custom Wordlist") do |wordlist|
  	puts "Using Wordlist #{wordlist} \n\n"
  	File.expand_path(wordlist)
	options[:words] = File.readlines(wordlist).map(&:chomp)  
  end

  opts.on("-s", "--save=<outfile.txt>", "Save output to a file") do |outfile|
  	puts "Saving output to file #{outfile} \n\n"
  end
end.parse!

def host_ip_hash(options)
   options[:words].each do |word|
   	_hash = {}
     begin
   	  _hash[:host] = word + "." + options[:domain]
   	  ip = Resolv.getaddress(word + "." + options[:domain])
   	  _hash[:ip] = ip
   	  check_alive(_hash)
   	 rescue Resolv::ResolvError
   	  next
   	 end
   end
end

def check_alive(_host_ip_hash)
  	begin
    Timeout::timeout(2) do
      begin
        sock = TCPSocket.new(_host_ip_hash[:ip], 80)
        puts _host_ip_hash[:host] + ", " + _host_ip_hash[:ip]
        sock.close
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      end
    end
    rescue Timeout::Error
    end
end

host_ip_hash(options)