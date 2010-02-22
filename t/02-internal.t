


$output=$hex->_expand_extend($input);
$intermediate={
	   a => [
		 {
		  x => 'first',
		  y => 'second',
		 },      
		],
	   b => [
		 'a',
		 {
		  extends => 'a',
		  y => 'third',
		  z => 'fourth',
		 },
		],
	c => [
	      {
	       y => 'stuff',
	       z => {
		     color => 'blue',
		     flavor => 'spicy',
		    },
	      },
	      ],
	d => [
	      'b',
	      'c',
	      {
	       extends => [qw/b c/],
	       z => { 
		     flavor => 'mild',
		    },
	      },
	     ],
       };
is_deeply($output, $intermediate, "checking _expand_extend");

$output=$hex->_compact_extend($intermediate);
is_deeply($output, $expected, "checking _compact_extend");

