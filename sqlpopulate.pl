#!/usr/bin/perl

=begin
    Make sure to replace the placeholders  your_database_name ,  your_database_host ,  your_database_username ,
    and  your_database_password  with the appropriate values for your database configuration.
    This script uses the DBI module to connect to the MySQL database and execute the SQL statements to create tables
    and insert sample data. It assumes that you have the necessary Perl modules and a MySQL database already set up.
    After running the script, it will populate the database with the provided table schema and sample data.

=cut

use strict;
use warnings;
use DBI;

# Database configuration
my $db_name = $ENV{'DATABASE_NAME'};
my $db_host = $ENV{'DATABASE_HOST'};
my $db_user = $ENV{'DATABASE_USERNAME'};
my $db_pass = $ENV{'DATABASE_PASSWORD'};

# SQL statements to create tables
my $create_users_table = <<'SQL';
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    enabled BOOLEAN NOT NULL
)
SQL

my $create_authorities_table = <<'SQL';
CREATE TABLE authorities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL
)
SQL

# SQL statements to insert sample data
my $insert_users_data = <<'SQL';
INSERT INTO users (username, password, enabled)
VALUES
    ('user1', 'password1', 1),
    ('user2', 'password2', 1),
    ('user3', 'password3', 0)
SQL

my $insert_authorities_data = <<'SQL';
INSERT INTO authorities (username, role)
VALUES
    ('user1', 'ROLE_USER'),
    ('user2', 'ROLE_ADMIN'),
    ('user3', 'ROLE_USER')
SQL

# Connect to the database
my $dbh = DBI->connect("DBI:mysql:$db_name:$db_host", $db_user, $db_pass)
    or die "Cannot connect to the database: $DBI::errstr";

# Create tables
$dbh->do($create_users_table);
$dbh->do($create_authorities_table);

# Insert sample data
$dbh->do($insert_users_data);
$dbh->do($insert_authorities_data);

# Disconnect from the database
$dbh->disconnect;

print "Database population completed successfully.\n";

