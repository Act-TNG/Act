package Act::Schema::Result::OrderItem;
use utf8;
use Act::Schema::Candy;

table "order_items";

column "item_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    sequence           => 'order_items_item_id_seq',
};

column "order_id" => {
    data_type          => 'integer',
};

column "amount" => {
    data_type          => 'integer',
};

column "name" => {
    data_type          => 'text',
};

column "registration" => {
    data_type          => 'boolean',
};


primary_key "item_id";

belongs_to "order" => "Act::Schema::Result::Order",
    { order_id => "order_id" },
    {},
;

1;
