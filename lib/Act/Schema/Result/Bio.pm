package Act::Schema::Result::Bio;
use utf8;
use Act::Schema::Candy;

table "bios";

column "user_id" => {
    data_type          => 'integer',
};

column "lang" => {
    data_type          => 'text',
};

column "bio" => {
    data_type          => 'text',
};

unique_constraint "bios_idx" => ["user_id", "lang"];

belongs_to "user" => "Act::Schema::Result::User",
    { user_id => "user_id" },
    {},
;

1;
