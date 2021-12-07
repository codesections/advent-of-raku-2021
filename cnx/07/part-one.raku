my @input = map +*, split ',', trim slurp 'input';
sub cost($align) { [+] map { abs $align - $_ }, @input }
put min (cost $_ for (min @input)...(max @input))
