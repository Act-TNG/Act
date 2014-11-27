package Act::Schema::Result::NewsItem;
use utf8;
use Act::Schema::Candy;

table "news_items";

column "news_item_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    is_nullable        => 0,
    sequence           => 'news_items_news_item_id_seq',
};

column "news_id" => {
    data_type          => 'integer',
    is_foreign_key     => 1,
    is_nullable        => 0,
};

column "lang" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "title" => {
      data_type        => 'text',
      is_nullable      => 0,
};

column "text" => {
    data_type          => 'text',
    is_nullable        => 0,
};

primary_key "news_item_id";

unique_constraint "news_items_news_id_key" => ["news_id", "lang"];

belongs_to "news" => "Act::Schema::Result::News",
  { news_id => "news_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" };

1;
