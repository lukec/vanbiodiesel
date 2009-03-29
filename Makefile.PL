use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'VanBio',
    AUTHOR              => 'Luke Closs <cpan@5thplane.com>',
    VERSION_FROM        => 'lib/VanBio.pm',
    ABSTRACT_FROM       => 'lib/VanBio.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Socialtext::Resting::Utils' => 0,
        'Socialtext::WikiObject'     => 0,
        'Template'                   => 0,
        'File::Path'                 => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'VanBio-* web/*' },
);
