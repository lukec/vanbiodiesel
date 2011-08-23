package VanBio;
use strict;
use warnings;
use Template;
use File::Path qw/rmtree mkpath/;
use Fatal qw/rmtree mkpath/;
use Carp qw/croak/;
use Socialtext::WikiObject;

=head1 NAME

VanBio - code to render the vancouverbiodiesel.org website

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This code reads content from the Socialtext REST API and renders it using TT2.

    use VanBio;

    VanBio->new(
        template_dir => "$blah/template",
        output_dir   => "$blah/web",
        static_dir   => "$blah/static",
    )->render;
        
=cut

sub new {
    my $class = shift;
    my $self = { @_ };

    for (qw/output_dir static_dir template_dir/) {
        croak "$_ is required!" unless $self->{$_};
    }
    bless $self, $class;

    return $self;
}

sub render {
    my $self = shift;

    $self->clean_output;
    $self->copy_static;
    $self->render_page('index');
    $self->render_page('news');
    $self->render_page('photos');
}

sub clean_output {
    my $self = shift;

    rmtree $self->{output_dir} if -d $self->{output_dir};
    mkpath $self->{output_dir};
}

sub copy_static {
    my $self = shift;

    system("cp -R $self->{static_dir}/* $self->{output_dir}");
}

sub render_page {
    my $self = shift;
    my $page = shift;
    my $vars = shift || { page => $page };

    my $template = Template->new({
        INCLUDE_PATH => [$self->{template_dir}],
    });

    my $output_file = "$self->{output_dir}/$page.html";
    $template->process("$page.html.tt2", $vars, $output_file)
        || die $template->error();
}

=head1 AUTHOR

Luke Closs, C<< <cpan at 5thplane.com> >>

=head1 ACKNOWLEDGEMENTS

Thanks to the authors and designers of the Socialtext REST API.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Luke Closs, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
