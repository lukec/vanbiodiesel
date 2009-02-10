package VanBio;
use strict;
use warnings;
use Template;
use File::Path qw/rmtree mkpath/;
use Fatal qw/rmtree mkpath/;
use Carp qw/croak/;
use Socialtext::WikiObject;

sub new {
    my $class = shift;
    my $self = { @_ };

    for (qw/output_dir static_dir template_dir rester/) {
        croak "$_ is required!" unless $self->{$_};
    }
    bless $self, $class;

    $self->{rester}->accept('text/html');
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

    my $content = $self->_get_page_html('home page');
    $self->_render_page( 'index', { content => $content } );
}

sub render_news {
    my $self = shift;

    my $content = $self->_get_page_html('news page');
    $self->_render_page( 'news', { content => $content } );
}

sub render_join {
    my $self = shift;

    my $content = $self->_get_page_html('join page');
    $self->_render_page( 'join', { content => $content } );
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

    $self->{rester}->accept('text/x.socialtext-wiki');
    my $page = Socialtext::WikiObject->new(
        rester => $self->{rester},
        page => 'links page',
    );
    my $links = [];
    my $link_table = $page->{links}{table};
    shift @$link_table; # pop off the header row
    for my $row (@$link_table) {
        push @$links, {
            href => $row->[0],
            name => $row->[1],
            desc => $row->[2],
        };
    }

    $self->_render_page( 'links', { links => $links } );
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

sub _get_page_html {
    my $self = shift;
    my $page = shift;
    $self->{rester}->accept('text/html');
    return $self->{rester}->get_page($page);
}
1;
