package Act::Schema::Result::Talk;
use utf8;
use Act::Schema::Candy;

table "talks";

column "talk_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    is_nullable        => 0,
    sequence           => 'talks_talk_id_seq',
};

column "conf_id" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "user_id" => {
    data_type          => 'integer',
    is_foreign_key     => 1,
    is_nullable        => 0,
};

column "title" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "abstract" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "url_abstract" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "url_talk" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "duration" => {
    data_type          => 'integer',
    is_nullable        => 1,
};

column "lightning" => {
    data_type          => 'boolean',
    default_value      => \"false",
    is_nullable        => 0,
};

column "accepted" => {
    data_type          => 'boolean',
    default_value      => \"false",
    is_nullable        => 0,
};

column "confirmed" => {
    data_type          => 'boolean',
    default_value      => \"false",
    is_nullable        => 0,
};

column "comment" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "room" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "datetime" => {
    data_type          => 'timestamp',
    is_nullable        => 1,
};

column "track_id" => {
    data_type          => 'integer',
    is_foreign_key     => 1,
    is_nullable        => 1,
};

column "level" => {
    data_type          => 'integer',
    default_value      => 1,
    is_nullable        => 1,
};

column "lang" => {
    data_type          => 'text',
    is_nullable        => 1,
};

primary_key "talk_id";

belongs_to "track" => "Act::Schema::Result::Track",
    { track_id => "track_id" },
    {
      join_type     => "LEFT",
      on_delete     => "SET NULL",
    }
;

belongs_to "user" => "Act::Schema::Result::User",
    { user_id => "user_id" },
    {},
;

has_many "user_talks" => "Act::Schema::Result::UserTalk",
    { "foreign.talk_id" => "self.talk_id" },
    {},
;

1;
