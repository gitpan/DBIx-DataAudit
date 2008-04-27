#!/usr/bin/perl -w
use strict;
use DBIx::DataAudit;
use Getopt::Long;
use Pod::Usage;

use vars '$VERSION';
$VERSION = '0.04';

GetOptions(
  'format|f:s' => \my $format,
  'dsn:s'        => \my $dsn,
  'verbose|v'  => \my $verbose,
  'help|h'     => \my $display_help,
  'man'        => \my $display_man,
) or pod2usage(2);
pod2usage(1) if $display_help;
pod2usage(-verbose => 2) if $display_man;


$format ||= 'text';
my ($table,$traits) = @ARGV;
$traits ||= '';

my @tables = split /,/, $table;
my @traits = split /,/, $traits;

die "No table name given.\n"
    unless @tables;

my %method = (
    'text' => 'as_text',
    'html' => 'as_html',
);
my $method = $method{$format} || 'as_text';

for my $table (@tables) {
    my $audit = DBIx::DataAudit->audit( dsn => $dsn, table => $table, traits => \@traits );
    if ($verbose) {
        warn $audit->get_sql . "\n";
    };
    print $audit->$method;
};

__END__

=head1 NAME

dbix-audit.pl - summary of column values for a table

=head1 SYNOPSIS

dbix-audit.pl [options] tables traits

Options:

  --format  output format (text or html)
  --dsn     DBI dsn to connect to
  --help    help message
  --man     full documentation

The tables are a comma-separated list of table names.

The traits are a comma-separated list of trait names.

=head1 OPTIONS

=over 4

=item B<--dsn>

Gives the DBI DSN

=item B<--format FORMAT>

Formats the output. Valid values are C<html> and C<text> (default).

=back

=head1 DESCRIPTION

This program is a commandline frontend to L<DBIx::DataAudit>. It
will display a short audit of the column values for a table.

=cut
