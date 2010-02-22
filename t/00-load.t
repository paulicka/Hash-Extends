#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Hash::Extends' );
}

diag( "Testing Hash::Extends $Hash::Extends::VERSION, Perl $], $^X" );
