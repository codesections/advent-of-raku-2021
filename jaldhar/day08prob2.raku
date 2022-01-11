#!/usr/bin/raku

sub decode(@signals) {
    my @decoded;

    @decoded[1] = @signals.grep({ $_.chars == 2 })[0];
    @decoded[7] = @signals.grep({ $_.chars == 3 })[0];
    @decoded[4] = @signals.grep({ $_.chars == 4 })[0];
    @decoded[8] = @signals.grep({ $_.chars == 7 })[0];
    @decoded[6] = @signals.grep({ $_.chars == 6 && ($_.comb ∪ @decoded[1].comb) ≡ (@decoded[8].comb) })[0];
    @decoded[5] = @signals.grep({ $_.chars == 5 && ($_.comb ∪ @decoded[6].comb)  ≢  (@decoded[8].comb) })[0];
    @decoded[2] = @signals.grep({ $_.chars == 5 && ($_.comb ∪ @decoded[5].comb) ≡ (@decoded[8].comb) })[0];
    @decoded[9] = @signals.grep({ $_.chars == 6 && ($_.comb ∪ @decoded[4].comb) ≢  (@decoded[8].comb) })[0];
    @decoded[0] = @signals.grep({ $_.chars == 6 && ($_.comb ∪ @decoded[5].comb) ≡ (@decoded[8].comb) })[0];
    @decoded[3] = (@signals ∖ @decoded).keys[0];
 
    return @decoded.map({ $_.comb.sort.join }).antipairs;
}

sub MAIN() {
    my $total = 0;

    for './input/day08.input'.IO.lines -> $line {
        my @fields = $line.split(/\s+/);
        my @signals = @fields.splice(0, 10);
        my @output = @fields.splice(1, 4);

        my %decoded = decode(@signals);
        $total += @output.map({ %decoded{$_.comb.sort.join}; }).join;
    }

    say $total;
}
