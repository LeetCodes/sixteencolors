package SixteenColors::Controller::File;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

SixteenColors::Controller::File - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched SixteenColors::Controller::File in File.');
}

sub instance : Chained('/pack/instance') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $file = $c->stash->{ pack }->files( { filename => $id } )->first;

    if( !$file ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        return;
    }

    $c->stash->{ file } = $file;
}

sub view : Chained('instance') :PathPart('') :Args(0) {
}

sub thumbnail : Chained('instance') :PathPart('thumbnail') :Args(0) {
    my( $self, $c ) = @_;

    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    my $path = $c->path_to( '/root/static/tn', $pack->canonical_name, $file->filename . '.png' );

    $file->generate_thumbnail( $path ) unless -e $path;

    $c->serve_static_file( $path );
}

sub fullscale : Chained('instance') :PathPart('fullscale') :Args(0) {
    my( $self, $c ) = @_;

    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    my $path = $c->path_to( '/root/static/fs', $pack->canonical_name, $file->filename . '.png' );

    $file->generate_fullscale( $path ) unless -e $path;

    $c->serve_static_file( $path );
}

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;