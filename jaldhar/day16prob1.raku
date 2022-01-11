#!/usr/bin/raku

my $totalVersions = 0;

class Packet {
    has $.version is rw;
    has @.data is rw;
}

sub parse($bits is rw) {
    my Packet @packets;
    my $pos = 0;

    while $pos < $bits.chars {
        @packets.push(packet($bits, $pos));
    }

    return @packets;
}

sub packet($bits is rw, $pos is rw) {
    my $packet = Packet.new;

    $packet.version = version($bits, $pos);
    $packet.data.push(literalOrOperator($bits, $pos));
    packing($bits, $pos);

    return $packet;
}

sub version($bits is rw, $pos is rw) {
    my $version = $bits.substr($pos, 3).parse-base(2);
    $pos += 3;

    $totalVersions += $version;

    return $version;
}

sub literalOrOperator($bits is rw, $pos is rw) {
    my $type = $bits.substr($pos, 3).parse-base(2);
    $pos += 3;

    return $type == 4 ?? literal($bits, $pos) !! operator($bits, $pos);
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
    my $packet = Packet.new;

    $packet.version = version($bits, $pos);
    $packet.data.push(literalOrOperator($bits, $pos));

    return $packet;
}

sub MAIN() {
    my $bits = './input/day16.input'.IO.lines[0]
        .comb
        .map({ $_.parse-base(16); })
        .map({ sprintf("%04b", $_); })
        .join;

    parse($bits);
    say $totalVersions;
}