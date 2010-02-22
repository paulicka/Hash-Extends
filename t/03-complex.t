# That all works for full sets, but...what about per node requests?

$hex->set_store($input);

$output=$hex->extend_get('d');
is_deeply($output, $expected->{d}, "checking extend_get");

my $mmo=$data->{inputs}->{mmo};
my $orcs=$mmo->{races}->{orcs}->{people};
foreach my $name (keys %$orcs){
  my $orc=$orcs->{$name};
  my $class=$orc->{class};
  
  $hex->extends_get($class, { store => $orcs->{classes} });
}

# Vacuum
# h mvc
# mvc t
{
  package Plugin::Test;
  sub handles {
    return [
	    [ c => 'Page' ],
	    [ m => 'Data' ],
	    [ v => 'TT' ],
	    ];
  }
  sub handle {

  }
}

