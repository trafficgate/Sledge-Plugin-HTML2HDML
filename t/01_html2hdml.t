# $Id$
use strict;
use Test::More tests => 2;
use lib 't/lib';

package Mock::Pages;
use base qw(Sledge::TestPages);
use vars qw($TMPL_PATH);
$TMPL_PATH = "t";

use Sledge::Plugin::HTML2HDML;

sub dispatch_foo { }

package main;

{
    local $ENV{HTTP_USER_AGENT} = "DoCoMo/1.0 P504iS";
    my $p = Mock::Pages->new;
    $p->dispatch('foo');
    my $out = $p->output;
    like $out, qr/<form action="index" method="GET">/;
}

{
    local $ENV{HTTP_USER_AGENT} = "UP.Browser/2.1";
    my $p = Mock::Pages->new;
    $p->dispatch('foo');
    my $out = $p->output;
    like $out, qr/<ACTION /;
}
