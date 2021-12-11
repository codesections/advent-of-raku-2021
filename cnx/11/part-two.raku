sub adj($i, $k) { [&&] map -2 < * < 2, [«-»] map { polymod $_: 10 }, ($i, $k) }
sub flash(@level) {
    my $i = first * > 9, @level, :k;
    return map { max $_, 0 }, @level without $i;
    flash map { $i == $^k ?? -8 !! $^v + adj $i, $^k }, @level.kv
}
sub step(@level) { (0 == all @level) ?? 0 !! 1 + step flash @level »+» 1 }
my $input = lines slurp 'input';
put step $input.join.comb
