#!/usr/bin/raku

class Packet {
    has $.version is rw;
    has $.value is rw;
}

sub parse($bits is rw) {
    my Packet @packets;
    my $pos = 0;
    my $value = 0;

    while $pos < $bits.chars {
        $value += packet($bits, $pos);
    }

    return $value;
}

sub packet($bits is rw, $pos is rw) {
    my $packet = Packet.new(
        version => version($bits, $pos),
        value => packetType($bits, $pos));
    packing($bits, $pos);

    return $packet.value;
}

sub version($bits is rw, $pos is rw) {
    my $version = $bits.substr($pos, 3).parse-base(2);
    $pos += 3;

    return $version;
}

sub packetType($bits is rw, $pos is rw) {
    my $type = $bits.substr($pos, 3).parse-base(2);
    $pos += 3;

    given $type {
        when 0 {
            return sum($bits, $pos);
        }
        when 1 {
            return product($bits, $pos);
        }
        when 2 {
            return minimum($bits, $pos);
        }
        when 3 {
            return maximum($bits, $pos);
        }
        when 4 {
            return literal($bits, $pos);
        }
        when 5 {
            return greaterThan($bits, $pos);
        }
        when 6 {
            return lessThan($bits, $pos);
        }
        when 7 {
            return equal($bits, $pos);
        }
    }
}

sub literal($bits is rw, $pos is rw) {
    my $buffer;

    while (my $digit = digit($bits, $pos)) {
        $buffer ~= $digit;
    }
    $buffer ~= lastDigit($bits, $pos);

    return $buffer.parse-base(2);
}

sub digit($bits is rw, $pos is rw) {
    my $type = $bits.substr($pos, 1);
    if $type == 0 {
        return Nil;
    }

    my $digit = $bits.substr($pos + 1, 4);
    $pos += 5;

    return $digit;
}

sub lastDigit($bits is rw, $pos is rw) {
    my $type = $bits.substr($pos, 1);
    if $type == 1 {
        return Nil;
    }

    my $digit = $bits.substr($pos + 1, 4);
    $pos += 5;

    return $digit;
}

sub packing($bits is rw, $pos is rw) {
    if $pos % 8 {
        $pos += 8 - $pos % 8;
    }
}

sub operator($bits is rw, $pos is rw) {
    my $type = $bits.substr($pos, 1);
    $pos += 1;
    
    return
      $type == 1 ?? packetsBySize($bits, $pos) !! packetsByLength($bits, $pos);
}

sub packetsBySize($bits is rw, $pos is rw) {
    my $length = $bits.substr($pos, 11).parse-base(2);
    $pos += 11;

    my @packets;
    for 0 ..^ $length {
        @packets.push(subpacket($bits, $pos));
    }

    return @packets;
}

sub packetsByLength($bits is rw, $pos is rw) {
    my $length = $bits.substr($pos, 15).parse-base(2);
    $pos += 15;

    my $end = $pos + $length;
    my @packets;
    while $pos < $end {
        @packets.push(subpacket($bits, $pos));
    }

    return @packets;
}

sub subpacket($bits is rw, $pos is rw) {
    return Packet.new(
        version => version($bits, $pos),
        value => packetType($bits, $pos)
    );
}

sub sum($bits is rw, $pos is rw) {
    return [+] operator($bits, $pos).map({ $_.value; });
}

sub product($bits is rw, $pos is rw) {
    return [*] operator($bits, $pos).map({ $_.value; });
}

sub minimum($bits is rw, $pos is rw) {
    return operator($bits, $pos).map({ $_.value; }).min;
}

sub maximum($bits is rw, $pos is rw) {
    return operator($bits, $pos).map({ $_.value; }).max;
}

sub lessThan($bits is rw, $pos is rw) {
    my @packets = operator($bits, $pos);
    return @packets[0].value < @packets[1].value ?? 1 !! 0;
}

sub greaterThan($bits is rw, $pos is rw) {
    my @packets = operator($bits, $pos);
    return @packets[0].value > @packets[1].value ?? 1 !! 0;
}

sub equal($bits is rw, $pos is rw) {
    my @packets = operator($bits, $pos);
    return @packets[0].value == @packets[1].value ?? 1 !! 0;
}

sub MAIN() {
    my $bits = './input/day16.input'.IO.lines[0]
        .comb
        .map({ $_.parse-base(16); })
        .map({ sprintf("%04b", $_); })
        .join;

    say parse($bits);
}