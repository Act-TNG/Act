package Act::Schema::Result::Bio;
use utf8;
use Act::Schema::Candy;

table "bios";

column "user_id" => {
    data_type          => 'integer',
    is_nullable        => 1,
};

column "lang" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "bio" => {
    data_type          => 'text',
    is_nullable        => 1,
};

unique_constraint "bios_idx" => ["user_id", "lang"];

belongs_to "user" => "Act::Schema::Result::User",
    { user_id => "user_id" },
    {},
;

1;
