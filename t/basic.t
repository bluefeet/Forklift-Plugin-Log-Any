#!/usr/bin/env perl
use Test2::Bundle::Extended ':v1';
use strictures 2;

use Test::Forklift;
use Log::Any::Test;
use Log::Any qw($log);

my $test = Test::Forklift->new(
    plugins => ['::Log::Any'],
);

$test->test();
$log->clear();

subtest plugin => sub{
    my $lift = $test->new_manager();

    $lift->do(
        'foo-job',
        sub{ return ['foo'] },
    );
    $lift->wait();

    $log->contains_ok(qr{Running the foo-job job\.}, 'running job logged');
    $log->contains_ok(qr{The foo-job job finished successfully\.}, 'finished job logged');
    $log->contains_ok(qr{Running callback for the foo-job job\.}, 'running callback logged');
    $log->contains_ok(qr{The callback for the foo-job job finished\.}, 'finished callback logged');
    $log->empty_ok('no other logs were recorded');
};

done_testing;
