package Act::Schema::Result::News;
use utf8;
use Act::Schema::Candy;

table "news";

column "news_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    sequence           => 'news_news_id_seq',
};

column "conf_id" => {
    data_type          => 'text',
};

column "datetime" => {
    data_type          => 'timestamp',
};

column "user_id" => {
    data_type          => 'integer',
};

column "published" => {
    data_type          => 'boolean',
    default_value      => \"false",
};

primary_key "news_id";

has_many "news_items" => "Act::Schema::Result::NewsItem",
    { "foreign.news_id" => "self.news_id" },
    {},
;

belongs_to "user" => "Act::Schema::Result::User",
    { "foreign.user_id" => "self.user_id" },
    {},
;

1;
