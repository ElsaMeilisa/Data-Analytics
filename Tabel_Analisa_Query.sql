-- Langkah 1
CREATE OR REPLACE TABLE `kimia_farma.Tabel_Analisa` AS
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  b.branch_name,
  b.kota,
  b.provinsi,
  b.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  p.price AS actual_price,
  t.discount_percentage
FROM
  `kimia_farma.kf_final_transaction` AS t
JOIN
  `kimia_farma.kf_product` AS p
  ON t.product_id = p.product_id
JOIN
  `kimia_farma.kf_kantor_cabang` AS b
  ON t.branch_id = b.branch_id;

-- Langkah 3

CREATE OR REPLACE TABLE `kimia_farma.Tabel_Analisa_Final` AS
SELECT
  a.*,
  CASE
    WHEN a.actual_price <= 50000 THEN 0.10
    WHEN a.actual_price <= 100000 THEN 0.15
    WHEN a.actual_price <= 300000 THEN 0.20
    WHEN a.actual_price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  a.actual_price * (1 - a.discount_percentage/100) AS nett_sales,

  a.actual_price * (1 - a.discount_percentage/100) *
  CASE
    WHEN a.actual_price <= 50000 THEN 0.10
    WHEN a.actual_price <= 100000 THEN 0.15
    WHEN a.actual_price <= 300000 THEN 0.20
    WHEN a.actual_price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  tr.rating AS rating_transaksi
FROM
  `kimia_farma.Tabel_Analisa` AS a
JOIN
  `kimia_farma.kf_final_transaction` AS tr
ON
  a.transaction_id = tr.transaction_id;

