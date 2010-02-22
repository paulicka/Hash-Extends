#!perl -T
use strict;
use warnings;

use Test::More tests => 3;

BEGIN {
  use_ok('Hash::Extends');
  use_ok('YAML::Syck', qw(Load));
}

my $data=Load(join('', <DATA>));

my $hex=Hash::Extends->new;

my ($input, $output, $intermediate, $expected);

# Assume arrayref of objects, and merges them together
$input=$data->{inputs}->{compact};
$expected=$data->{expected}->{compact};

# Default compact is default merge
$output=$hex->compact($input);
is_deeply($output, $expected, "checking compact");

$input={
	a => {
	      x => 'first',
	      y => 'second',
	     },
	b => {
	      extends => 'a',
	      y => 'third',
	      z => 'fourth',
	     },
	c => {
	      y => 'stuff',
	      z => {
		    color => 'blue',
		    flavor => 'spicy',
		   },
	     },
	d => {
	      extends => [qw/b c/],
	      z => { 
		    flavor => 'mild',
		   },
	     },
       };
$expected={
	   a => {
		 x => 'first',
		 y => 'second',
		},
	   b => {
		 extends => 'a',
		 x => 'first',
		 y => 'third',
		 z => 'fourth',
		},
	   c => {
		 y => 'stuff',
		 z => {
		       color => 'blue',
		       flavor => 'spicy',
		      },
		},
	   d => {
		 extends => [qw/b c/],
		 x => 'first',
		 y => 'stuff',
		 z => { 
		       color => 'blue',
		       flavor => 'mild',
		      },
		},
	  };

$output=$hex->extend($input);
is_deeply($output, $expected, "checking extend");

__DATA__
inputs:
  mmo:
    races:
      basic:
        classes:
          peasant:
            physical:
              offense: 5
              defense: 5
            magical:
              offense: 0
              defense: 2
          weapon_user:
            extends: peasant
            physical:
              defense: 20
          magic_user:
            extends: peasant
            magical:
              defense: 20
          warriors:
            extends: weapon_user
            physical:
              defense: 30
              offense: 20
          healer:
            extends: peasant
            healing:
              defense: 20
              offense: 20
      evil:
        extends: basic
        classes:
          mage:
            extends: magic_user
            magical:
              defense: 30
              offense: 20
      orcs:
        extends: [evil, basic]
        classes:
          shaman:
            extends: [magic_user, healer]
            magical: 
              offense: 10
            healing:
              offense: 10
          people:
            UgUg:
              class: cleric
  victum:
    layers:
      default:
        controllers:
          mine:
            class: Page
            model: 
              name: stuff
              size: medium
              count: 15
            view: lookit
            children:
              first: other
        models:
          stuff:
            class: Data
            key: value
            size: big
            count: 23
        views:
          lookit:
            class: TT
            template: 'my/template.tt'
            model_class: Data

  compact:
    - a: 27
      b: monkey
      c: 
        d: pig
      e: [my, great, stuff]
    - b: baboon
      c:
        d: ~
        f: muskrat
      e: [and, other, stories]
      g: what now?

expected:
  compact:
    a: 27
    b: baboon
    c:
      d: ~
      f: muskrat
    e: [my, great, stuff, and, other, stories]
    g: what now?
