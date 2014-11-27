package Act::Schema::Result::InvoiceNum;
use utf8;
use Act::Schema::Candy;

table "invoice_num";

column "conf_id" => {
    data_type          => 'text',
};

column "next_num" => {
    data_type          => 'integer',
};

primary_key "conf_id";

1;
