use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'      => 'Sledge::Plugin::HTML2HDML',
    'VERSION_FROM' => 'lib/Sledge/Plugin/HTML2HDML.pm', # finds $VERSION
    'PREREQ_PM' => {
	Test::More => 0.32,
	HTTP::MobileAgent => 0,
    },
);
