#!/usr/bin/perl
###################################################################
 # populateDBTables.pl                                             #
# Author: ax56                                                    #
 # This script populates the DynamoDB tables on aws with data from #
# the  DynamoDB files automatically using a perl script rather    #
 # than the aws cli and a an unsecure json file run from a shell   #
# script...              plus perl is ALIVE!                      #
###################################################################
use strict;
use warnings;
use JSON;
use Data::Dumper;
use LWP::UserAgent;
my $ua = LWP::UserAgent->new;
$ua->timeout(20);
$ua->env_proxy;
### read the file into an array, but conceal the region, key and secret key
### with '*' for each character in the string.
my @file = `cat /home/ax56/.aws/credentials`;
my $region = $file[1];
### remove the new line character from the end of the string
chomp($region);
### remove the 'region = ' from the string
$region =~ s/region = //;
### replace each character in the string with a '*'
$region =~ s/./\*/g;
my $key = $file[2];
chomp($key);
$key =~ s/aws_access_key_id = //;
### hide the key with '*'
$key =~ s/./\*/g;
### bash script that had the aws commands, this could be done here as well,
### but I wanted to keep the script as simple as possible.
my @lines = `cat configurations/commands.sh`;
### loop through the array and execute the commands with a traditional 4loop
for (my $idx = 0; $idx < scalar(@lines); $idx++) {
    my $line = $lines[$idx];
    chomp($line);
    print "Executing: $line";
    system($line);
### sleep for 20 seconds to allow the table to be created
    sleep(20);
### get the table name from the command
    my @split = split(/ /, $line);
    my $table = $split[3];
### read the json file into an array
    my @json = `cat configurations/$table.json`;
### loop through the array and insert the data into the table on aws with a
    # 4each loop
    foreach my $json (@json) {
        chomp($json);
        my $json_obj = decode_json($json);
        my $json_str = encode_json($json_obj);
        my $url = "http://localhost:8080/$table";
        my $req = HTTP::Request->new(POST => $url);
        $req->header('Content-Type' => 'application/json');
        $req->content($json_str);
        my $res = $ua->request($req);
        if ($res->is_success) {
            print "Success: $res->decoded_content";
        } else {
            print "Error: $res->status_line";
        }
    }
}



