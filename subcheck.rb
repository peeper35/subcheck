#!/usr/bin/env ruby
require 'optparse'
require 'resolv'
require 'socket'
require 'timeout'

ARGV << '-h' if ARGV.empty?
ARGV << '-h' if !ARGV.include?('-d')

options = {}



OptionParser.new do |opts|
  opts.banner = "Usage: ruby sub_bruteforcer.rb -d <target domain> // optional -w <wordlist> -o <outfile>"

  opts.on("-d", "--domain=<domain>", "Target Domain") do |domain|
    options[:domain] = domain
  end

  opts.on("-w", "--wordlist=<wordlist>", "Custom Wordlist") do |wordlist|
  	puts "Using Wordlist #{wordlist} \n\n"
	options[:words] = File.readlines(File.expand_path(wordlist)).map(&:chomp)  
  end

  opts.on("-o", "--outfile=<outfile.txt>", "Save output to a file") do |outfile|
  	puts "Saving output to file #{outfile} \n\n"
  	options[:outfile] = outfile
  end
end.parse!

if !options[:words]
  puts "Using default wordlist \n\n"
  options[:words] = File.readlines('wordlist.txt').map(&:chomp)
end

def host_ip_hash(options)
   options[:words].each_with_index do |word, index|
   	_hash = {}
     begin
   	  _hash[:host] = word + "." + options[:domain]
          _hash[:count_index] = index
   	  ip = Resolv.getaddress(word + "." + options[:domain])
   	  _hash[:ip] = ip
   	  check_alive(_hash, options)
   	 rescue Resolv::ResolvError
   	  next
   	 end
   end
end

def check_alive(_host_ip_hash, options)
  	begin
    Timeout::timeout(2) do
      begin
        sock = TCPSocket.new(_host_ip_hash[:ip], 80)
        puts "[" + _host_ip_hash[:count_index].to_s + "] " + _host_ip_hash[:host] + ", " + _host_ip_hash[:ip]
           if options[:outfile]
	          otf = File.open(options[:outfile], "a")
	          otf << _host_ip_hash[:host] + ", " + _host_ip_hash[:ip] + "\n"
	       end
        sock.close
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      end
    end
    rescue Timeout::Error
    end
end

host_ip_hash(options)
