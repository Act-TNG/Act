package Act::Schema::Result::Order;
use utf8;
use Act::Schema::Candy;

table "orders";

column "order_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    is_nullable        => 0,
    sequence           => 'orders_order_id_seq',
};

column "conf_id" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "user_id" => {
    data_type          => 'integer',
    is_foreign_key     => 1,
    is_nullable        => 0,
};

column "datetime" => {
    data_type          => 'timestamp',
    is_nullable        => 0,
};

column "means" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "currency" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "status" => {
    data_type          => 'text',
    is_nullable        => 0,
}; 

column "type" => {
    data_type          => 'text',
    is_nullable        => 1,
};

primary_key "order_id";

might_have "invoice" => "Act::Schema::Result::Invoice",
  { "foreign.order_id" => "self.order_id" },
  { cascade_copy => 0, cascade_delete => 0 };

has_many "order_items" => "Act::Schema::Result::OrderItem",
  { "foreign.order_id" => "self.order_id" },
  { cascade_copy => 0, cascade_delete => 0 };

belongs_to "user" => "Act::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" };

1;
