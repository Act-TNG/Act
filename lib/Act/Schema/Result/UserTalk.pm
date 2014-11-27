package Act::Schema::Result::UserTalk;
use utf8;
use Act::Schema::Candy;

table "user_talks";

column "user_id" => {
    data_type          => 'integer',
    is_foreign_ke      => 1,
    is_nullable        => 0,
};

column "conf_id" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "talk_id" => {
    data_type          => 'integer',
    is_foreign_key     => 1,
    is_nullable        => 0,
};


belongs_to "talk" => "Act::Schema::Result::Talk",
  { talk_id => "talk_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" };

belongs_to "user" => "Act::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" };

1;
