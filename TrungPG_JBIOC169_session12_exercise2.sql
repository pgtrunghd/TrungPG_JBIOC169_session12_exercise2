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

CREATE OR REPLACE FUNCTION check_stock()
RETURNS TRIGGER AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT stock INTO v_stock FROM products
    WHERE product_id = NEW.product_id;

    IF v_stock < NEW.quantity THEN
        RAISE EXCEPTION 'Not enough stock';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_check_stock
BEFORE INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION check_stock();

INSERT INTO products (name, stock) VALUES
('Điện thoại iPhone 15', 10),
('Tai nghe AirPods Pro', 5);

INSERT INTO sales (product_id, quantity) VALUES
(1, 5);

INSERT INTO sales (product_id, quantity) VALUES
(2, 10);

SELECT * FROM products;
SELECT * FROM sales;
