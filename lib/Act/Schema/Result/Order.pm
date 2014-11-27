package Act::Schema::Result::Order;
use utf8;
use Act::Schema::Candy;

table "orders";

column "order_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    sequence           => 'orders_order_id_seq',
};

column "conf_id" => {
    data_type          => 'text',
};

column "user_id" => {
    data_type          => 'integer',
};

column "datetime" => {
    data_type          => 'timestamp',
};

column "means" => {
    data_type          => 'text',
};

column "currency" => {
    data_type          => 'text',
};

column "status" => {
    data_type          => 'text',
}; 

column "type" => {
    data_type          => 'text',
    is_nullable        => 1,
};

primary_key "order_id";

might_have "invoice" => "Act::Schema::Result::Invoice",
    { "foreign.order_id" => "self.order_id" },
    {},
;

has_many "order_items" => "Act::Schema::Result::OrderItem",
    { "foreign.order_id" => "self.order_id" },
    {},
;

belongs_to "user" => "Act::Schema::Result::User",
    { user_id => "user_id" },
    {},
;

1;
