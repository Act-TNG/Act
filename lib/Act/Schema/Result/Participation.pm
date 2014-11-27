package Act::Schema::Result::Participation;
use utf8;
use Act::Schema::Candy;

table "participations";

column "conf_id" => {
    data_type          => 'text',
};

column "user_id" => {
    data_type          => 'integer',
};

column "tshirt_size" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "nb_family" => {
    data_type          => 'integer',
    default_value      => 0,
    is_nullable        => 1,
};

column "datetime" => {
    data_type          => 'timestamp',
    is_nullable        => 1,
};

column "ip" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "attended" => {
    data_type          => 'boolean',
    default_value      => \"false",
    is_nullable        => 1,
};


belongs_to "user" => "Act::Schema::Result::User",
    { user_id => "user_id" },
    {},
;

1;
