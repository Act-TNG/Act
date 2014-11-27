package Act::Schema::Result::Invoice;
use utf8;
use Act::Schema::Candy;

table "invoices";

column "invoice_id" => {
    data_type          => 'integer',
    is_auto_increment  => 1,
    sequence           => 'invoices_invoice_id_seq',
};

column "order_id" => {
    data_type          => 'integer',
};

column "datetime" => {
    data_type          => 'timestamp',
};

column "invoice_no" => {
    data_type          => 'integer',
};

column "amount" => {
    data_type        => 'integer',
};

column "means" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "currency" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "first_name" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "last_name" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "company" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "address" => {
    data_type          => 'text',
    is_nullable        => 1,
};

column "vat" => {
    data_type          => 'text',
    is_nullable        => 1,
};

primary_key "invoice_id";

unique_constraint "invoices_idx" => ["order_id"];

belongs_to "order" => "Act::Schema::Result::Order",
    { order_id => "order_id" },
    {},
;

1;
