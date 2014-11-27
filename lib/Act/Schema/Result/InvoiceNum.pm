package Act::Schema::Result::InvoiceNum;
use utf8;
use Act::Schema::Candy;

table "invoice_num";

column "conf_id" => {
    data_type          => 'text',
    is_nullable        => 0,
};

column "next_num" => {
    data_type          => 'integer',
    is_nullable        => 0,
};

primary_key "conf_id";

1;
