my &cum = { $_ * ($_ + 1) div 2 };
my @input = map +*, split ',', trim slurp 'input';
sub cost($align) { [+] map { cum abs $align - $_ }, @input }
put min (cost $_ for (min @input)...(max @input))
