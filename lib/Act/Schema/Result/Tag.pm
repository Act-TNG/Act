package Act::Schema::Result::Tag;
use utf8;
use Act::Schema::Candy;

table "tags";

column "tag_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    is_nullable        => 0,
    sequence           => 'tags_tag_id_seq',
};

column "conf_id" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "tag" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "type" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "tagged_id" => {
    data_type          => 'text',
    is_nullable        => 0,
};

primary_key "tag_id";

1;
