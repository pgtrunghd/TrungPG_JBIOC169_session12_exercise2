CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    stock INT
);

-- 2. Tạo bảng sales
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT
);

create or replace function check_stock()
returns trigger as $$
declare
    v_stock int;
begin
    select stock into v_stock from products
    where product_id =  new.product_id;

    if v_stock < new.quantity then
        raise exception 'Not enough stock';
    end if;

    return new;
end;
$$ language plpgsql;


create trigger trg_check_stock
before insert on sales
for each row
execute function check_stock();

INSERT INTO products (name, stock) VALUES 
('Điện thoại iPhone 15', 10),
('Tai nghe AirPods Pro', 5);

INSERT INTO sales (product_id, quantity) VALUES
(1, 5);

INSERT INTO sales (product_id, quantity) VALUES
(2, 10);

select * from products;
select * from sales;