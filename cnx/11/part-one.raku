sub adj($i, $k) { [&&] map -2 < * < 2, [«-»] map { polymod $_: 10 }, ($i, $k) }
sub flash(@level, $count) {
    my $i = first * > 9, @level, :k;
    return ({ max $_, 0 } for @level), $count without $i;
    flash ({ $i == $^k ?? -8 !! $^v + adj $i, $^k } for @level.kv), $count + 1
}
sub step($times, @level, $count=0) {
    return $count unless $times > 0;
    step $times - 1, |flash @level »+» 1, $count
}
my $input = lines slurp 'input';
put step 100, $input.join.comb
