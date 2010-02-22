use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Hash::Extends',
    license             => 'perl',
    dist_author         => q{Christopher Paulicka <paulicka@twiceborn.com>},
    dist_version_from   => 'lib/Hash/Extends.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Hash-Extends-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
