package VanBio;
use strict;
use warnings;
use Template;
use File::Path qw/rmtree mkpath/;
use Fatal qw/rmtree mkpath/;
use Carp qw/croak/;

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
    $self->render_homepage;
    $self->render_news;
    $self->render_join;
    $self->render_photos;
    $self->render_press;
    $self->render_links;
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

sub render_homepage {
    my $self = shift;
    $self->_render_page( 'index' );
}

sub render_news {
    my $self = shift;
    $self->_render_page( 'news' );
}

sub render_join {
    my $self = shift;
    $self->_render_page( 'join' );
}

sub render_photos {
    my $self = shift;
    $self->_render_page( 'photos' );
}

sub render_press {
    my $self = shift;
    $self->_render_page( 'press' );
}

sub render_links {
    my $self = shift;
    $self->_render_page( 'links' );
}

sub _render_page {
    my $self = shift;
    my $page = shift;
    my $vars = shift || {};

    my $template = Template->new({
        INCLUDE_PATH => [$self->{template_dir}],
    });

    my $output_file = "$self->{output_dir}/$page.html";
    $template->process("$page.html.tt2", $vars, $output_file)
        || die $template->error();
}

1;
