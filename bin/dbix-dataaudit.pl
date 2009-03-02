#!/usr/bin/perl -w
use strict;
use DBIx::DataAudit;
use Getopt::Long;
use Pod::Usage;

use vars '$VERSION';
$VERSION = '0.11';

GetOptions(
  'format|f:s' => \my $format,
  'dsn:s'      => \my $dsn,
  'outname|o:s'=> \my $outname,
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
    'text' => sub { $_[0]->as_text },
    'html' => sub { $_[0]->as_html },
    'xls'  => \&output_xls,
);

my $wb;
sub output_xls {
    require Spreadsheet::WriteExcel;
    my ($audit) = @_;
    $outname ||= 'dataaudit.xls';

    $wb ||= Spreadsheet::WriteExcel->new($outname);

    my $data = $audit->template_data();

    (my $name = $data->{table}) =~ s/^\w+\.//;
    my $ws = $wb->add_worksheet($name);
    $ws->write_row(0,0,$data->{headings});
    $ws->write_col(1,0,$data->{rows});
};

for my $table (@tables) {
    my $audit = DBIx::DataAudit->audit( dsn => $dsn, table => $table, traits => \@traits );
    if ($verbose) {
        warn $audit->get_sql . "\n";
    };
    print $method{$format}->($audit);
};


__END__

=head1 NAME

dbix-audit.pl - summary of column values for a table

=head1 SYNOPSIS

dbix-audit.pl [options] tables traits

Options:

  --format  output format (text,xls or html)
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
