package Act::Schema::Result::Right;
use utf8;
use Act::Schema::Candy;

table "rights";

column "right_id" => {
    data_type          => 'text',
};

column "conf_id" => {
    data_type          => 'text',
};

column "user_id" => {
    data_type          => 'integer',
};

belongs_to "user" => "Act::Schema::Result::User",
    { user_id => "user_id" },
    {},
;

1;
