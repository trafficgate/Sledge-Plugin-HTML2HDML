package Sledge::Plugin::HTML2HDML;

use strict;
use vars qw($VERSION);
$VERSION = 0.01;

use File::Temp qw(tempdir tempfile);
use HTTP::MobileAgent;

sub import {
    my $class = shift;
    my $pkg   = caller;
    $pkg->register_hook(
	AFTER_DISPATCH => sub {
	    my $self = shift;
	    my $agent = HTTP::MobileAgent->new();
	    if ($agent->is_ezweb && $agent->is_wap1) {
		$self->add_filter(\&filter_html2hdml);
	    }
	},
    );
}

sub filter_html2hdml {
    my($page, $content) = @_;
    $page->r->content_type('text/x-hdml; charset=Shift_JIS');
    my $command = eval { $page->create_config->html2hdml } || "html2hdml";
    return _pipe_out($command, $content);
}

sub _pipe_out {
    my($command, $content) = @_;
    # XXX why not IPC::Open2?
    my $dir = tempdir(CLEANUP => 1);
    my($fh, $filename) = tempfile(DIR => $dir);
    print $fh $content;
    close $fh;
    return qx($command $filename);
}

1;
__END__

=head1 NAME

Sledge::Plugin::HTML2HDML - html2hdml filter

=head1 SYNOPSIS

  package Your::Pages;
  use Sledge::Plugin::HTML2HDML;

  # when html2hdml is not in your PATH
  package Your::Config;
  $C{HTML2HDML} = "/path/to/html2hdml";

=head1 DESCRIPTION

Sledge::Plugin::HTML2HDML は、端末がEZweb WAP/1.0 対応機の場合に、C<html2hdml>フィルタを通し、HTTPレスポンスヘッダを適切に返すプラグインです。

動作にはC<html2hdml>プログラムと、C<HTTP::MobileAgent>モジュールが必要です。

  html2hdml
  https://sourceforge.jp/projects/html2hdml/

  HTTP::MobileAgent
  http://search.cpan.org/dist/HTTP-MobileAgent/

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@edge.co.jpE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Sledge itself.

=head1 SEE ALSO

L<html2hdml>, L<HTTP::MobileAgent>

=cut
