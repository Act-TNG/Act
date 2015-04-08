package Act::Schema::Result::Conference;
use utf8;
use Act::Schema::Candy;

=head1 NAME

Act::Schema::Result::Conference

=head1 DESCRIPTION

An object that will be the 'root' to which most of the other object are related.

Most data about a conference is being kept in config.ini files over the
file-system. L<Act::Schema::Result::Config> will store the actual data.

=head1 TABLE: C<conferences>

=cut

table "conferences";

=head1 ACCESSORS

=head2 conf_id

This is the old legacy foreign_key for Act, usually as a 'user string' like NLPW2015

=cut

column "conf_id" => {
    data_type          => 'text',
};

=head2 syndicate

Act enables delegation of administration, a syndicate can autonomous create instances
of a community event.

=cut

column "syndicate" => {
    data_type          => 'text',
};

=head2 edition

An edition is a delegated community event, under authority of previous mentioned orga

=cut

column "edition" => {
    data_type          => 'text',
};

=head1 PRIMARY KEY

=over 4

=item * L</conf_id>

=back

=cut

primary_key "conf_id";

=head1 UNIQUE CONSTRAINTS

=head2 C<conferences_syndicate_edition_key>

=over 4

=item * L</syndicate>

=item * L</edition>

=back

=cut

unique_constraint "conferences_syndicate_edition_key" => ["syndicate", "edition"];

=head1 RELATIONS

=head2 events

has_many related object: L<Act::Schema::Result::Event>

=cut

has_many "events" => "Act::Schema::Result::Event",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 invoice_num

has_many related object: L<Act::Schema::Result::InvoiceNum>

=cut

has_many "invoice_num" => "Act::Schema::Result::InvoiceNum",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 news

has_many related object: L<Act::Schema::Result::News>

=cut

has_many "news" => "Act::Schema::Result::News",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 orders

has_many related object: L<Act::Schema::Result::Order>

=cut

has_many "orders" => "Act::Schema::Result::Order",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 participations

has_many related object: L<Act::Schema::Result::Participation>

=cut

has_many "participations" => "Act::Schema::Result::Participation",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 rights

has_many related object: L<Act::Schema::Result::Right>

=cut

has_many "rights" => "Act::Schema::Result::Right",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 tags

has_many related object: L<Act::Schema::Result::Tag>

=cut

has_many "tags" => "Act::Schema::Result::Tag",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 talks

has_many related object: L<Act::Schema::Result::Talk>

=cut

has_many "talks" => "Act::Schema::Result::Talk",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 tracks

has_many related object: L<Act::Schema::Result::Track>

=cut

has_many "tracks" => "Act::Schema::Result::Track",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;

=head2 user_talks

has_many related object: L<Act::Schema::Result::UserTalk>

=cut

has_many "user_talks" => "Act::Schema::Result::UserTalk",
    { "foreign.conf_id" => "self.conf_id" },
    {},
;


=head1 COPYRIGHT

(c) 2015 - Th.J. van Hoesel - THEMA-MEDIA NL

=cut

1;
