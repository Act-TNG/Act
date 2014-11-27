package Act::Schema::Result::UserTalk;
use utf8;
use Act::Schema::Candy;

table "user_talks";

column "user_id" => {
    data_type          => 'integer',
};

column "conf_id" => {
    data_type          => 'text',
};

column "talk_id" => {
    data_type          => 'integer',
};


belongs_to "talk" => "Act::Schema::Result::Talk",
    { talk_id => "talk_id" },
    {},
;

belongs_to "user" => "Act::Schema::Result::User",
    { user_id => "user_id" },
    {},
;

1;
