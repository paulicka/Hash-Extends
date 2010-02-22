package Hash::Extends;
use warnings;
use strict;

use Log::Any qw($log);

sub new {
  my $proto=shift;
  my $class=ref($proto)||$proto;
  my $params=shift||{};
  my $object=bless $params, $class;

  $object->{merge}=$object->default_merge unless $object->{merge};
  die "Strange...merge object should have merge method"
    unless $object->{merge}->can('merge');

  return $object;
}

sub default_merge {
    require Hash::Merge;
    return Hash::Merge->new('RIGHT_PRECEDENT');
}

sub compact {
  my ($self, $array)=@_;
  die "First argument must be array" unless ref($array) eq 'ARRAY';

  return $self->{merge}->merge(@$array);
}

sub extend {
  my ($self, $store)=@_;

  die "First argument must be hash" unless ref($store) eq 'HASH';

  my $expand=$self->_expand_extend($store);

  return $self->_compact_extend($expand);
}

sub _expand_extend {
  my ($self, $store)=@_;

  my $expand={};
  my @keys=keys %$store;
  while (@keys){
    my $key=shift(@keys);
    my $base=$store->{$key};

    my $extends=$base->{extends}||[];
    my @extends=(ref($extends) eq 'ARRAY') ? @$extends : [$extends];
    
    if (@extends){
      use Data::Dumper;
      warn "extends: ", Dumper(\@extends);

    die "Whoops...unknown extends in @extends for $key"
      unless scalar @extends == scalar grep { $store->{$_} } @extends;
  }

    # All expand have been done...
    my @extend_bases=grep { $expand->{$_} } @extends;
    if (@extend_bases == @extends){
      $expand->{$key}=[(map { @$_ } @extend_bases), $base];
    } else {
      $log->debug("Pushing $key since @extends not all found");
      push(@keys, $key);
    }
  }
  return $expand;
}

sub _compact_extend {
  my ($self, $expand)=@_;

  return { map { $_ => $self->compact(@{$expand->{$_}}) } keys %$expand};
}


=head1 NAME

Hash::Extends - The great new Hash::Extends!

=head1 VERSION

Version 0.01

=cut

use version; our $VERSION = 'v0.0.1';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Hash::Extends;

    my $foo = Hash::Extends->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Christopher Paulicka, C<< <paulicka at twiceborn.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-hash-extends at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Hash-Extends>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Hash::Extends


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Hash-Extends>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Hash-Extends>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Hash-Extends>

=item * Search CPAN

L<http://search.cpan.org/dist/Hash-Extends/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2010 Christopher Paulicka.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Hash::Extends
