package Act::Schema::Result::Tag;
use utf8;
use Act::Schema::Candy;

table "tags";

column "tag_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    sequence           => 'tags_tag_id_seq',
};

column "conf_id" => {
    data_type          => 'text',
};

column "tag" => {
    data_type          => 'text',
};

column "type" => {
    data_type          => 'text',
};

column "tagged_id" => {
    data_type          => 'text',
};

primary_key "tag_id";

1;
