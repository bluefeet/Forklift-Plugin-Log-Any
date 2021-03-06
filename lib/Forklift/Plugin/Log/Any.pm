package Forklift::Plugin::Log::Any;

=head1 NAME

Forklift::Plugin::Log::Any - Automatically log Forklift activity.

=head1 SYNOPSIS

    use Forklift;
    
    my $lift = Forklift->new(
        plugins => ['::Log::Any'],
    );

=head1 DESCRIPTION

This L<Forklift> plugin uses L<Log::Any> to produce logs at several points
during job processing.

=cut

use Log::Any qw( $log );

use Moo::Role;
use strictures 2;
use namespace::clean;

use MooX::PluginKit::Plugin;

plugin_applies_to 'Forklift::Job';

=head1 LOG MESSAGES

=head2 job start

When a job begins running an C<info> message like the following is produced:

    Running the JOB_ID job.

=head2 job success

When a job finished successfully an C<info> message like the following is produced:

    The JOB_ID job finished successfully.

=head2 job failure

When a job throws an exception while running an C<error> message like the following is produced:

    The JOB_ID job failed: ERROR

=cut

around run => sub{
    my $orig = shift;
    my $self = shift;

    $log->infof(
        'Running the %s job.',
        $self->id(),
    );

    my $result = $self->$orig( @_ );

    my $log_method = $result->{succcess} ? 'infof' : 'errorf';
    $log->$log_method(
        'The %s job %s',
        $self->id(),
        $result->{success}
            ? 'finished successfully.'
            : 'failed: ' . $result->{error},
    );

    return $result;
};

=head2 callback start

When a callback begins running an C<info> message like the following is produced:

    Running callback for the JOB_ID job.

=head2 callback finish

When the callback finished running an C<info> message like the following is produced:

    The callback for the JOB_ID job finished.

=cut

around run_callback => sub{
    my $orig = shift;
    my $self = shift;

    $log->infof(
        'Running callback for the %s job.',
        $self->id(),
    );

    $self->$orig( @_ );

    $log->infof(
        'The callback for the %s job finished.',
        $self->id(),
    );

    return;
};

1;
__END__

=head1 TODO

For now this plugin only inserts logging into L<Forklift::Job/run> and
L<Forklift::Job/run_callback>.  In the future more may be logged and it
may be useful to make the log levels configurable.

=head1 SUPPORT

Feature requests, pull requests, and discussion can be had on GitHub at
L<https://github.com/bluefeet/Forklift-Plugin-Log-Any>.  You are also
welcome to email the author directly.

=head1 AUTHOR

Aran Clary Deltac <bluefeetE<64>gmail.com>

=head1 ACKNOWLEDGEMENTS

Thanks to L<ZipRecruiter|https://www.ziprecruiter.com/>
for encouraging their employees to contribute back to the open
source ecosystem.  Without their dedication to quality software
development this distribution would not exist.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

