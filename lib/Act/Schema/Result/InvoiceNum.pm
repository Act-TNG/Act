package Act::Schema::Result::InvoiceNum;
use utf8;
use Act::Schema::Candy;

=head1 NAME

Act::Schema::Result::InvoiceNum

=head1 DESCRIPTION

Helps to keep track of the invoices per Community Event

=head1 TABLE: C<invoice_num>

=cut

table "invoice_num";

=head1 ACCESSORS

=head2 conf_id

Cummunity Event ID.

=cut

column "conf_id" => {
    data_type          => 'text',
};

=head2 next_num

Invoice sequence number per Cumminity Event.

=cut

column "next_num" => {
    data_type          => 'integer',
};

=head1 PRIMARY KEY

=over 4

=item * L</conf_id>

=back

=cut

primary_key "conf_id";

=head1 RELATIONS

=head2 conference

belongs_to related object: L<Act::Schema::Result::Conference>

=cut

belongs_to "conference" => "Act::Schema::Result::Conference",
    { conf_id => "conf_id" },
    {
      join_type     => "LEFT",
      on_delete     => "SET NULL",
    }
;

=head1 COPYRIGHT

(c) 2015 - Th.J. van Hoesel - THEMA-MEDIA NL

=cut

1;
