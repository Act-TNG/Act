package Act::Schema::Result::User;
use utf8;
use Act::Schema::Candy;

table "users";

column "user_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    sequence           => 'users_user_id_seq',
};

column "login" => {
    data_type          => 'text',
};

column "passwd" => {
    data_type          => 'text',
};

column "session_id" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "salutation" => {
    data_type          => 'integer',
    is_nullable        => 1,
};

column "first_name" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "last_name" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "nick_name" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "pseudonymous" => {
    data_type          => 'boolean',
    default_value      => \"false",
    is_nullable        => 1,
};

column "country" => {
    data_type          => 'text',
};

column "town" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "web_page" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "pm_group" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "pm_group_url" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "email" => {
    data_type          => 'text',
};

column "email_hide" => {
    data_type          => 'boolean',
    default_value      => \"true",
};

column "gpg_key_id" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "pause_id" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "monk_id" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "monk_name" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "im" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "photo_name" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "language" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "timezone" => {
    data_type          => 'text',
};

column "company" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "company_url" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "address" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "vat" => {
    data_type          => 'text',
    is_nullable        => 1,
};

primary_key "user_id";

unique_constraint "users_login" => ["login"];

unique_constraint "users_session_id" => ["session_id"];

has_many "orders" => "Act::Schema::Result::Order",
    { "foreign.user_id" => "self.user_id" },
    {},
;

has_many "participations" => "Act::Schema::Result::Participation",
    { "foreign.user_id" => "self.user_id" },
    {},
;

has_many "rights" => "Act::Schema::Result::Right",
    { "foreign.user_id" => "self.user_id" },
    {},
;

has_many "talks" => "Act::Schema::Result::Talk",
    { "foreign.user_id" => "self.user_id" },
    {},
;

has_many "user_talks" => "Act::Schema::Result::UserTalk",
    { "foreign.user_id" => "self.user_id" },
    {},
;

1;
