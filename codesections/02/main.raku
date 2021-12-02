use Test;

sub where-am-i(@dir, :$x is copy =0, :$z is copy =0) {
    when +@dir == 0 { $x, $z }
    given @dir[0].words {
        when .[0] eq 'forward' { $x += .[1]}
        when .[0] eq 'up'      { $z -= .[1]}
        when .[0] eq 'down'    { $z += .[1]}
    }
    &?ROUTINE(@dir[1..*], :$x, :$z)
}

sub where-am-i2(@dir, :$x is copy =0, :$z is copy =0, :$aim is copy = 0) {
    when +@dir == 0 { $x, $z }
    given @dir[0].words {
        when .[0] eq 'forward' { $x += .[1]; $z += (.[1] * $aim)}
        when .[0] eq 'up'      { $aim -= .[1]}
        when .[0] eq 'down'    { $aim += .[1]}
    }
    &?ROUTINE(@dir[1..*], :$x, :$z, :$aim)
}

say [*] where-am-i('input.txt'.IO.lines);
say [*] where-am-i2('input.txt'.IO.lines);

my @t-in = q:to/eof/;
   forward 5
   down 5
   forward 8
   up 3
   down 8
   forward 2
   eof

where-am-i(@t-in.lines).&is((15, 10));
where-am-i2(@t-in.lines).&is((15, 60));
