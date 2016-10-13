package Dancer2::Plugin::Over;

use strict;
use warnings;
use Dancer2::Plugin;
use Scalar::Util ();

has 'over_subs' => (
    'is'      => 'ro',
    'default' => sub { +{} },
);

plugin_keywords( qw<add_over over> );

sub add_over {
    my ( $self, $sub_name, $sub ) = @_;

    return $self->over_subs->{$sub_name} = $sub;
}

sub over {
    my ( $self, $sub_name, @args ) = @_;

    my $sub = $self->over_subs->{$sub_name};
    Scalar::Util::weaken( my $inself = $self );

    return sub {
        $sub or $inself->dsl->pass;

        $sub->();
    };
}

1;



use Dancer2::Plugin::Over;

add_over random => sub {...};

get '/' => over random => sub {

};
