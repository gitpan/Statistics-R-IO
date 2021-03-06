#!perl -T
use 5.010;
use strict;
use warnings FATAL => 'all';

use Test::More tests => 30;
use Test::Fatal;

use Statistics::R::REXP::Logical;
use Statistics::R::REXP::List;

my $empty_vec = new_ok('Statistics::R::REXP::Logical', [  ], 'new logical vector' );

is($empty_vec, $empty_vec, 'self equality');

my $empty_vec_2 = Statistics::R::REXP::Logical->new();
is($empty_vec, $empty_vec_2, 'empty logical vector equality');

my $vec = Statistics::R::REXP::Logical->new(elements => [1, 0, 1, 0]);
my $vec2 = Statistics::R::REXP::Logical->new([3.3, '', 'bla', '0']);
is($vec, $vec2, 'logical vector equality');

is(Statistics::R::REXP::Logical->new($vec2), $vec, 'copy constructor');
is(Statistics::R::REXP::Logical->new(Statistics::R::REXP::List->new([3.3, '', ['bla', 0]])),
   $vec, 'copy constructor from a vector');

## error checking in constructor arguments
like(exception {
        Statistics::R::REXP::Logical->new(sub {1+1})
     }, qr/Attribute \(elements\) does not pass the type constraint/,
     'error-check in single-arg constructor');
like(exception {
        Statistics::R::REXP::Logical->new(1, 2, 3)
     }, qr/odd number of arguments/,
     'odd constructor arguments');
like(exception {
        Statistics::R::REXP::Logical->new(elements => {foo => 1, bar => 2})
     }, qr/Attribute \(elements\) does not pass the type constraint/,
     'bad elements argument');

my $another_vec = Statistics::R::REXP::Logical->new(elements => [1, 0, 1, undef]);
isnt($vec, $another_vec, 'logical vector inequality');

is($empty_vec .'', 'logical()', 'empty logical vector text representation');
is($vec .'', 'logical(1, 0, 1, 0)', 'logical vector text representation');
is($another_vec .'', 'logical(1, 0, 1, undef)', 'text representation with logical NAs');
is(Statistics::R::REXP::Logical->new(elements => [undef]) .'',
   'logical(undef)', 'text representation of a singleton NA');

is_deeply($empty_vec->elements, [], 'empty logical vector contents');
is_deeply($vec->elements, [1, 0, 1, 0], 'logical vector contents');
is($vec->elements->[2], 1, 'single element access');

is_deeply(Statistics::R::REXP::Logical->new(elements => [3.3, '', undef, 'foo'])->elements,
          [1, 0, undef, 1], 'constructor with undefined values');

is_deeply(Statistics::R::REXP::Logical->new(elements => [3.3, '', [0, ['00', undef]], 1])->elements,
          [1, 0, 0, 1, undef, 1], 'constructor from nested arrays');

ok(! $empty_vec->is_null, 'is not null');
ok( $empty_vec->is_vector, 'is vector');


## attributes
is_deeply($vec->attributes, undef, 'default attributes');

my $vec_attr = Statistics::R::REXP::Logical->new(elements => [1, 0, 1, 0],
                                                 attributes => { foo => 'bar',
                                                                 x => [40, 41, 42] });
is_deeply($vec_attr->attributes,
          { foo => 'bar', x => [40, 41, 42] }, 'constructed attributes');

my $vec_attr2 = Statistics::R::REXP::Logical->new(elements => [1, 0, 1, 0],
                                                  attributes => { foo => 'bar',
                                                                  x => [40, 41, 42] });
my $another_vec_attr = Statistics::R::REXP::Logical->new(elements => [1, 0, 1, 0],
                                                         attributes => { foo => 'bar',
                                                                         x => [40, 42, 42] });
is($vec_attr, $vec_attr2, 'equality considers attributes');
isnt($vec_attr, $vec, 'inequality considers attributes');
isnt($vec_attr, $another_vec_attr, 'inequality considers attributes deeply');

## attributes must be a hash
like(exception {
        Statistics::R::REXP::Logical->new(attributes => 1)
     }, qr/Attribute \(attributes\) does not pass the type constraint/,
     'setting non-HASH attributes');

## Perl representation
is_deeply($empty_vec->to_pl,
          [], 'empty vector Perl representation');

is_deeply($vec->to_pl,
          [1, 0, 1, 0], 'Perl representation');

is_deeply($another_vec->to_pl,
          [1, 0, 1, undef], 'NA-heavy vector Perl representation');

