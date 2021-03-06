package SixteenColors::API::Controller::Year;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'SixteenColors::API::Base::Controller';
}

sub base : Chained('/') PathPrefix CaptureArgs(0) {}

sub list : Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $c->model( 'DB::Year' ) );
}

sub instance : Chained('base') PathPart('') CaptureArgs(1) {
    my( $self, $c, $arg ) = @_;

    $c->stash->{ year } = $c->model( 'DB::Year' )->find( $arg );

    if( !$c->stash->{ year } ) {
        $self->status_not_found( $c, message => 'Invalid Year' );
        $c->detach;
    }
}

sub view : Chained('instance') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $c->stash->{ year }->packs_rs );
}

sub month : Chained('instance') PathPart('') Args(1) {
    my( $self, $c, $arg ) = @_;

    my $packs = $c->model( 'DB::Pack' )->search(
        { year => $c->request->captures->[ 0 ], month => $arg }
    );

    $self->status_ok( $c, entity => $packs );
}

1;

__END__

=head1 NAME

SixteenColors::API::Controller::Year - Year Controller for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 list

Attempt to render a view, if needed.

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
