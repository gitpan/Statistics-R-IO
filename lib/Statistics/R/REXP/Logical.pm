package Statistics::R::REXP::Logical;

use 5.012;

use Moo;
use namespace::clean;

with 'Statistics::R::REXP::Vector';

has '+elements' => (
    coerce => sub {
        my $x = shift;
        [ map { defined $_ ? ($_ ? 1 : 0) : undef } _flatten(@{$x}) ] if ref $x eq ref []
    },
);


sub _type { 'logical'; }

1; # End of Statistics::R::REXP::Logical

=head1 NAME

Statistics::R::REXP::Logical - an R logical vector


=head1 VERSION

This documentation refers to version 0.02 of the module.


=head1 SYNOPSIS

    use Statistics::R::REXP::Logical
    
    my $vec = Statistics::R::REXP::Logical->new([
        1, '', 'foo', undef
    ]);
    print $vec->elements;


=head1 DESCRIPTION

An object of this class represents an R logical vector
(C<LGLSXP>).


=head1 METHODS

C<Statistics::R::REXP:Logical> inherits from
L<Statistics::R::REXP::Vector>, with the added restriction that its
elements are boolean (true/false) values. Elements have value 1 or 0,
corresponding to C<TRUE> and C<FALSE>, respectively, while missing
values (C<NA> in R) have value C<undef>.


=head1 BUGS AND LIMITATIONS

Classes in the C<REXP> hierarchy are intended to be immutable. Please
do not try to change their value or attributes.

There are no known bugs in this module. Please see
L<Statistics::R::IO> for bug reporting.


=head1 SUPPORT

See L<Statistics::R::IO> for support and contact information.


=head1 AUTHOR

Davor Cubranic, C<< <cubranic at stat.ubc.ca> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2014 University of British Columbia.

See L<Statistics::R::IO> for the license.

=cut