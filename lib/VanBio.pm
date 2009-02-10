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

    my $template = Template->new({
        INCLUDE_PATH => [$self->{template_dir}],
    });

    my $vars = {};
    my $output_file = "$self->{output_dir}/index.html";
    $template->process('main.html.tt2', $vars, $output_file)
        || die $template->error();
}

1;
