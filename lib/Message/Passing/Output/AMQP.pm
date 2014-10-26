package Message::Passing::Output::AMQP;
use Moose;
use namespace::autoclean;

with qw/
    Message::Passing::AMQP::Role::DeclaresExchange
    Message::Passing::Role::Output
/;

has routing_key => (
    isa => 'Str',
    is => 'ro',
    default => '',
);

sub consume {
    my $self = shift;
    my $data = shift;
    if (ref $data) {
        warn("Passed non-serialized data - is a perl reference. Dropping.\n");
        return;
    }
    unless ($self->_exchange) {
        warn("No exchange yet, dropping message");
        return;
    }
    $self->_channel->publish(
        body => $data,
        exchange => $self->exchange_name,
        routing_key => $self->routing_key,
    );
}

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Message::Passing::Output::AMQP - output messages to AMQP.

=head1 SYNOPSIS

    message-pass --input STDIN --output AMQP --output_options '{"exchange_name":"test","hostname":"127.0.0.1","username":"guest","password":"guest"}'

=head1 DESCRIPTION

A L<Message::Passing> L<AnyEvent::RabbitMQ> output class.

Can be used as part of a chain of classes with the L<message-pass> utility, or directly as
a logger in normal perl applications.

=head1 METHODS

=head2 consume

Sends a message.

=head1 SEE ALSO

=over

=item L<Message::Passing::AMQP>

=item L<Message::Passing::Input::AMQP>

=item L<Message::Passing>

=item L<AMQP>

=item L<http://www.zeromq.org/>

=back

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing::AMQP>.

=cut

