package Act::Schema::Result::TwoStep;
use utf8;
use Act::Schema::Candy;

table "twostep";

column "token" => {
    data_type          => 'char',
    size               => 32,
};

column "email" => {
    data_type          => 'text',
};

column "datetime" => {
    data_type          => 'timestamp',
    is_nullable        => 1,
};

column "data" => {
    data_type          => 'text',
    is_nullable        => 1,
};

primary_key "token";

1;
