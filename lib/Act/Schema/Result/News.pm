package Act::Schema::Result::News;
use utf8;
use Act::Schema::Candy;

table "news";

column "news_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    is_nullable        => 0,
    sequence           => 'news_news_id_seq',
};

column "conf_id" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "datetime" => {
    data_type          => 'timestamp',
    is_nullable        => 0,
};

column "user_id" => {
    data_type          => 'integer',
    is_nullable        => 0,
};

column "published" => {
    data_type          => 'boolean',
    default_value      => \"false",
    is_nullable        => 0,
};

primary_key "news_id";

has_many "news_items" => "Act::Schema::Result::NewsItem",
    { "foreign.news_id" => "self.news_id" },
    {},
;

1;
