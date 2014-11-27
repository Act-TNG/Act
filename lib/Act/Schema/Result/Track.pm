package Act::Schema::Result::Track;
use utf8;
use Act::Schema::Candy;

table "tracks";

column "track_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    is_nullable        => 0,
    sequence           => 'tracks_track_id_seq',
};

column "conf_id" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "title" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "description" => {
    data_type          => 'text',
    is_nullable        => 1,
};

primary_key "track_id";

has_many "talks" => "Act::Schema::Result::Talk",
    { "foreign.track_id" => "self.track_id" },
    {},
;

1;
