# E-Commerce API Responses Documentation

Dokumen ini berisi contoh response (success & error) untuk setiap endpoint API.
Silakan edit struktur field dan tipe data di bawah ini sesuai dengan response backend kamu yang sebenarnya.

---

## 1. Authentication

### `POST /auth/login`

- **Request Body:**
  ```json
  {
    "email": "agussumanto@example.com",
    "password": "password123"
  }
  ```
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Login berhasil",
    "data": {
      "user": {
        "id": "2",
        "name": "Agus Sumanto",
        "email": "agussumanto@example.com",
        "role": "user"
      },
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIyIiwiZW1haWwiOiJhZ3Vzc3VtYW50b0BleGFtcGxlLmNvbSIsInJvbGUiOiJ1c2VyIiwidHlwZSI6InVzZXIiLCJpYXQiOjE3OTIzOTM0NTgsImV4cCI6MTc5Mjk5ODI1OH0.-MZCNjOuH4uopg9dhgvlcrZvdJTEvIMOw3Rn0CR2lJA"
    }
  }
  ```
- **Response 401 (Unauthorized):**
  ```json
  {
    "code": 401,
    "message": "Kredensial tidak valid (Email atau Password salah)."
  }
  ```
- **Response 403 (Forbidden):**
  ```json
  {
    "code": 403,
    "message": "Akun administrator tidak dapat login melalui portal pelanggan. Silakan gunakan portal admin."
  }
  ```

---

### `POST /auth/register`

- **Request Body:**
  ```json
  {
    "name": "Agus Sumanto",
    "email": "agussumanto@example.com",
    "password": "password123"
  }
  ```
- **Response 201 (Created):**
  ```json
  {
    "success": true,
    "message": "Registrasi berhasil",
    "data": {
      "id": 2,
      "name": "Agus Sumanto",
      "email": "agussumanto@example.com",
      "role": "user"
    }
  }
  ```
- **Response 400 (Bad Request):**
  ```json
  {
    "success": false,
    "message": "Email sudah terdaftar"
  }
  ```

---

### `GET /auth/me`

- **Headers:** `Authorization: Bearer <token>`
- **Response 201 (Created):**
  ```json
  {
    "code": 200,
    "message": "Berhasil mengambil profil pengguna",
    "data": {
      "id": "2",
      "name": "Agus Sumanto",
      "email": "agussumanto@example.com",
      "phone_number": null,
      "role": "user",
      "created_at": "2026-09-11T15:45:31.193Z"
    }
  }
  ```

---

## 2. Products Catalog (Public)

### `GET /products`

- **Query Parameters:** (opsional: `search`, `category_id`, `page`, `limit`)
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil mengambil daftar produk",
    "data": [
      {
        "id": "13",
        "name": "Sepatu Lari Cowok Mizuno Wave Rider Kasual Sporty Original",
        "price": "235000",
        "stock": 299,
        "image_url": "https://images.unsplash.com/photo-1718781412866-3b6b465ddb1e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "Sepatu"
      },
      {
        "id": "12",
        "name": "Polo Shirt Cowok Biru Dongker Kasual Blook Original",
        "price": "125000",
        "stock": 199,
        "image_url": "https://images.unsplash.com/photo-1717127036020-83774f354008?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "Fashion Pria"
      },
      {
        "id": "11",
        "name": "Kemeja Kerja Formal Cowok Light Blue Premium Blook Original",
        "price": "135000",
        "stock": 250,
        "image_url": "https://images.unsplash.com/photo-1717664233370-e896d5c2c57c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "Kemeja"
      },
      {
        "id": "10",
        "name": "Kemeja Kerja Formal Cowok Biru Dongker Premium Blook",
        "price": "135000",
        "stock": 250,
        "image_url": "https://images.unsplash.com/photo-1717664118692-b3a99dbf1ae4?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "Kemeja"
      },
      {
        "id": "9",
        "name": "Kemeja Kerja Formal Cowok Putih Bersih Blook Original",
        "price": "135000",
        "stock": 250,
        "image_url": "https://images.unsplash.com/photo-1717664118555-765f877cf355?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "Kemeja"
      },
      {
        "id": "8",
        "name": "Celana Jeans Cowok Black Denim Kasual Premium",
        "price": "285000",
        "stock": 300,
        "image_url": "https://images.unsplash.com/photo-1718252540511-e958742e4165?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "Jeans"
      },
      {
        "id": "7",
        "name": "Celana Jins Panjang Pria Denim Klasik Medium Blue Wash",
        "price": "285000",
        "stock": 300,
        "image_url": "https://images.unsplash.com/photo-1714143136372-ddaf8b606da7?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "Jeans"
      },
      {
        "id": "6",
        "name": "T-Shirt Polos - Putih",
        "price": "120000",
        "stock": 200,
        "image_url": "https://images.unsplash.com/photo-1651761179569-4ba2aa054997?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "T-Shirt"
      },
      {
        "id": "5",
        "name": "T-Shirt Polos - Hitam",
        "price": "120000",
        "stock": 200,
        "image_url": "https://images.unsplash.com/photo-1657364890995-1ec4bb3aefcf?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
        "category_name": "T-Shirt"
      },
      {
        "id": "3",
        "name": "Sepatu Running Adidas 2",
        "price": "1950000",
        "stock": 200,
        "image_url": "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
        "category_name": "Fashion Pria"
      },
      {
        "id": "1",
        "name": "Sepatu Running Nike",
        "price": "1250000",
        "stock": 14,
        "image_url": "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
        "category_name": "Fashion Pria"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "limit": 15,
      "totalItems": 11,
      "totalPages": 1,
      "hasPreviousPage": false,
      "hasNextPage": false
    }
  }
  ```

---

### `GET /products/:id`

- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil mengambil detail produk",
    "data": {
      "id": "5",
      "name": "T-Shirt Polos - Hitam",
      "description": "Kaos polos warna hitam\n\nBahan : Katun 100%",
      "price": "120000",
      "stock": 200,
      "image_url": "https://images.unsplash.com/photo-1657364890995-1ec4bb3aefcf?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
      "category_id": 12,
      "category_name": "T-Shirt"
    }
  }
  ```

---

## 3. Categories Management (Admin)

### `GET categories`

- **Query Parameters:** (opsional: `search`)
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil mengambil daftar kategori",
    "data": [
      {
        "id": 2,
        "name": "Fashion Pria",
        "slug": "fashion-pria",
        "icon_url": null,
        "created_at": "2026-09-11T16:13:04.601Z",
        "product_count": 3
      },
      {
        "id": 3,
        "name": "Fashion Wanita",
        "slug": "fashion-wanita",
        "icon_url": null,
        "created_at": "2026-09-11T16:13:04.601Z",
        "product_count": 0
      },
      {
        "id": 11,
        "name": "Jeans",
        "slug": "jeans",
        "icon_url": "https://img.icons8.com/?size=100&id=UVjezsXwiwyO&format=png&color=000000",
        "created_at": "2026-10-17T11:07:21.943Z",
        "product_count": 2
      },
      {
        "id": 10,
        "name": "Kemeja",
        "slug": "kemeja",
        "icon_url": "https://img.icons8.com/?size=100&id=IvczQQcatVwm&format=png&color=000000",
        "created_at": "2026-10-17T11:06:36.204Z",
        "product_count": 3
      },
      {
        "id": 9,
        "name": "Running",
        "slug": "running",
        "icon_url": "https://img.icons8.com/?size=100&id=WIDLqKl8UjI4&format=png&color=000000",
        "created_at": "2026-10-17T11:02:42.094Z",
        "product_count": 0
      },
      {
        "id": 13,
        "name": "Sepatu",
        "slug": "sepatu",
        "icon_url": "https://img.icons8.com/?size=100&id=TMpPyYdbbnZe&format=png&color=000000",
        "created_at": "2026-10-17T11:08:42.696Z",
        "product_count": 1
      },
      {
        "id": 12,
        "name": "T-Shirt",
        "slug": "t-shirt",
        "icon_url": "https://img.icons8.com/?size=100&id=9rqQCeziQzbz&format=png&color=000000",
        "created_at": "2026-10-17T11:07:48.514Z",
        "product_count": 2
      }
    ]
  }
  ```

---

### `GET categories/:id`

- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil mengambil detail kategori",
    "data": {
      "id": 2,
      "name": "Fashion Pria",
      "slug": "fashion-pria",
      "icon_url": null,
      "created_at": "2026-09-11T16:13:04.601Z",
      "product_count": 3
    }
  }
  ```

---

## 4. Cart (Customer Storefront)

### `GET /cart`

- **Headers:** `Authorization: Bearer <token>`
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil mengambil data keranjang",
    "data": {
      "items": [
        {
          "cart_item_id": 12,
          "product_id": 12,
          "product_name": "Polo Shirt Cowok Biru Dongker Kasual Blook Original",
          "price": "125000",
          "image_url": "https://images.unsplash.com/photo-1717127036020-83774f354008?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
          "quantity": 1,
          "subtotal": "125000"
        }
      ],
      "grand_total": 125000
    }
  }
  ```

### `POST /cart` (Tambah Item)

- **Headers:** `Authorization: Bearer <token>`
- **Request Body:**
  ```json
  {
    "product_id": 12,
    "quantity": 1
  }
  ```
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil menambahkan produk ke keranjang",
    "data": {
      "id": 12,
      "user_id": 2,
      "product_id": 12,
      "quantity": 1,
      "created_at": "2026-10-19T08:00:36.604Z",
      "updated_at": "2026-10-19T08:00:36.604Z"
    }
  }
  ```

### `PUT /cart/:id` (Update Quantity)

- **Headers:** `Authorization: Bearer <token>`
- **Request Body:**
  ```json
  {
    "quantity": 3
  }
  ```
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil memperbarui jumlah produk",
    "data": {
      "id": 12,
      "user_id": 2,
      "product_id": 12,
      "quantity": 2,
      "created_at": "2026-10-19T08:00:36.604Z",
      "updated_at": "2026-10-19T08:24:31.721Z"
    }
  }
  ```

### `DELETE /cart/:id` & `DELETE /cart` (Hapus Item / Clear Cart)

- **Headers:** `Authorization: Bearer <token>`
- **Response 200 (Success):**
  ```json
  {
    "success": true,
    "message": "Item keranjang berhasil diperbarui / dihapus"
  }
  ```

## 5. Orders & Payments (Customer Storefront)

### `POST /orders/checkout`

- **Headers:** `Authorization: Bearer <token>`
- **Request Body:**
  ```json
  {
    "shipping_address": "Jl. Kaliurang KM 5, Yogyakarta"
  }
  ```
- **Response 201 (Created):**
  ```json
  {
    "code": 201,
    "message": "Checkout berhasil. Pesanan Anda telah dibuat.",
    "data": {
      "id": "4",
      "user_id": "2",
      "total_amount": "125000",
      "status": "PENDING",
      "shipping_address": "Jl. Godean KM 5, Yogyakarta",
      "created_at": "2026-10-19T07:08:45.407Z",
      "updated_at": "2026-10-19T07:08:45.407Z",
      "payment_proof_url": null,
      "payment_submitted_at": null
    }
  }
  ```

---

### `POST /orders/:orderId/pay` (Upload Bukti Bayar)

- **Headers:** `Authorization: Bearer <token>`
- **Request Format:** `multipart/form-data`
- **Form Field:**
  - `proof_image`: File gambar (`image/jpeg`, `image/png`)
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Bukti pembayaran berhasil diunggah. Menunggu konfirmasi admin.",
    "data": {
      "id": "4",
      "user_id": "2",
      "total_amount": "125000",
      "status": "PROCESSING",
      "shipping_address": "Jl. Godean KM 5, Yogyakarta",
      "created_at": "2026-10-19T07:08:45.407Z",
      "updated_at": "2026-10-19T07:09:00.321Z",
      "payment_proof_url": "proof_4_1792393740612.png",
      "payment_submitted_at": "2026-10-19T07:09:00.321Z"
    }
  }
  ```

---

### `GET /orders`

- **Headers:** `Authorization: Bearer <token>`
- **Query Parameters:** (opsional: `status`, `page`, `limit`)
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil mengambil daftar pesanan",
    "data": [
      {
        "order_id": "4",
        "user_id": "2",
        "total_amount": 125000,
        "status": "SHIPPED",
        "shipping_address": "Jl. Godean KM 5, Yogyakarta",
        "payment_proof_url": "https://whpwzvkmzfgvfqtuvjld.supabase.co/storage/v1/object/sign/payment-proofs/proof_4_1792393740612.png?token=eyJraWQiOiJjMDBjNjM0NS04MzQ5LTRiMWQtODU3Yy1hNjU4YTVlN2U1MDUiLCJhbGciOiJIUzUxMiJ9.eyJ1cmwiOiJwYXltZW50LXByb29mcy9wcm9vZl80XzE3OTIzOTM3NDA2MTIucG5nIiwic2NvcGUiOiJkb3dubG9hZCIsImlhdCI6MTc5MjQwMjM1NywiZXhwIjoxNzkyNDA1OTU3fQ.E2g6ivX8HAaGYQOu_EgroSLZca-3HBiuYxexaDU_bEJP_QM0OBzg1Qae09lPEoq_Nyv9w8faKySGUhdD-Bpg9w",
        "payment_submitted_at": "2026-10-19T07:09:00.321Z",
        "created_at": "2026-10-19T07:08:45.407Z",
        "updated_at": "2026-10-19T08:31:51.033Z",
        "total_items": 1,
        "total_quantity": 1,
        "items": [
          {
            "order_item_id": 5,
            "product_id": 12,
            "product_name": "Polo Shirt Cowok Biru Dongker Kasual Blook Original",
            "product_image": "https://images.unsplash.com/photo-1717127036020-83774f354008?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
            "quantity": 1,
            "price_at_purchase": 125000,
            "subtotal": 125000
          }
        ]
      },
      {
        "order_id": "3",
        "user_id": "2",
        "total_amount": 235000,
        "status": "PROCESSING",
        "shipping_address": "Jl. Godean KM 5, Yogyakarta",
        "payment_proof_url": "https://whpwzvkmzfgvfqtuvjld.supabase.co/storage/v1/object/sign/payment-proofs/proof_3_1792393678707.png?token=eyJraWQiOiJjMDBjNjM0NS04MzQ5LTRiMWQtODU3Yy1hNjU4YTVlN2U1MDUiLCJhbGciOiJIUzUxMiJ9.eyJ1cmwiOiJwYXltZW50LXByb29mcy9wcm9vZl8zXzE3OTIzOTM2Nzg3MDcucG5nIiwic2NvcGUiOiJkb3dubG9hZCIsImlhdCI6MTc5MjQwMjM1NywiZXhwIjoxNzkyNDA1OTU3fQ.Y1w9wfDGXYMIxxJZ5FTxQt3YVznslgaTCEltzpCA0jpQhZ7fcjUTmmPHvnwOhmxXmPsJttwyiuryrYQ7DUkyxw",
        "payment_submitted_at": "2026-10-19T07:07:58.404Z",
        "created_at": "2026-10-19T07:06:04.237Z",
        "updated_at": "2026-10-19T07:07:58.404Z",
        "total_items": 1,
        "total_quantity": 1,
        "items": [
          {
            "order_item_id": 4,
            "product_id": 13,
            "product_name": "Sepatu Lari Cowok Mizuno Wave Rider Kasual Sporty Original",
            "product_image": "https://images.unsplash.com/photo-1718781412866-3b6b465ddb1e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
            "quantity": 1,
            "price_at_purchase": 235000,
            "subtotal": 235000
          }
        ]
      },
      {
        "order_id": "2",
        "user_id": "2",
        "total_amount": 1350000,
        "status": "COMPLETED",
        "shipping_address": "Jl. Godean KM 5, Yogyakarta",
        "payment_proof_url": "https://whpwzvkmzfgvfqtuvjld.supabase.co/storage/v1/object/sign/payment-proofs/proof_2_1792174931934.png?token=eyJraWQiOiJjMDBjNjM0NS04MzQ5LTRiMWQtODU3Yy1hNjU4YTVlN2U1MDUiLCJhbGciOiJIUzUxMiJ9.eyJ1cmwiOiJwYXltZW50LXByb29mcy9wcm9vZl8yXzE3OTIxNzQ5MzE5MzQucG5nIiwic2NvcGUiOiJkb3dubG9hZCIsImlhdCI6MTc5MjQwMjM1NywiZXhwIjoxNzkyNDA1OTU3fQ.6EazZdYpAPjiWyXM2sUzSpbqHPX6mC_heBplW5lOW7Zyb-XQiVciWSL5enilrldlBb45patkxZnUS0XlrIhgRg",
        "payment_submitted_at": "2026-10-16T18:22:11.636Z",
        "created_at": "2026-10-16T18:20:35.320Z",
        "updated_at": "2026-10-18T10:08:41.049Z",
        "total_items": 1,
        "total_quantity": 1,
        "items": [
          {
            "order_item_id": 3,
            "product_id": 2,
            "product_name": "Sepatu Running Nike 2",
            "product_image": "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
            "quantity": 1,
            "price_at_purchase": 1350000,
            "subtotal": 1350000
          }
        ]
      },
      {
        "order_id": "1",
        "user_id": "2",
        "total_amount": 2600000,
        "status": "PENDING",
        "shipping_address": "Jl. Kaliurang KM 5, Yogyakarta",
        "payment_proof_url": null,
        "payment_submitted_at": null,
        "created_at": "2026-10-11T16:34:24.272Z",
        "updated_at": "2026-10-11T16:34:24.272Z",
        "total_items": 2,
        "total_quantity": 2,
        "items": [
          {
            "order_item_id": 1,
            "product_id": 1,
            "product_name": "Sepatu Running Nike",
            "product_image": "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
            "quantity": 1,
            "price_at_purchase": 1250000,
            "subtotal": 1250000
          },
          {
            "order_item_id": 2,
            "product_id": 2,
            "product_name": "Sepatu Running Nike 2",
            "product_image": "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
            "quantity": 1,
            "price_at_purchase": 1350000,
            "subtotal": 1350000
          }
        ]
      }
    ],
    "pagination": {
      "currentPage": 1,
      "limit": 10,
      "totalItems": 4,
      "totalPages": 1,
      "hasPreviousPage": false,
      "hasNextPage": false
    }
  }
  ```

---

### `GET /orders/:id`

- **Headers:** `Authorization: Bearer <token>`
- **Response 200 (Success):**
  ```json
  {
    "code": 200,
    "message": "Berhasil mengambil detail pesanan",
    "data": {
      "id": "4",
      "user_id": "2",
      "total_amount": 125000,
      "status": "SHIPPED",
      "shipping_address": "Jl. Godean KM 5, Yogyakarta",
      "payment_proof_url": "https://whpwzvkmzfgvfqtuvjld.supabase.co/storage/v1/object/sign/payment-proofs/proof_4_1792393740612.png?token=eyJraWQiOiJjMDBjNjM0NS04MzQ5LTRiMWQtODU3Yy1hNjU4YTVlN2U1MDUiLCJhbGciOiJIUzUxMiJ9.eyJ1cmwiOiJwYXltZW50LXByb29mcy9wcm9vZl80XzE3OTIzOTM3NDA2MTIucG5nIiwic2NvcGUiOiJkb3dubG9hZCIsImlhdCI6MTc5MjQwMjIwNSwiZXhwIjoxNzkyNDA1ODA1fQ.ZVzcKOBfms-IZa-Andl2Y6Zderj6kczwsrdfQnyuiSKm72DLxYBhGxiqkQmIhQAY_D-ecHGf5U2DFYFy_eSALA",
      "payment_submitted_at": "2026-10-19T07:09:00.321Z",
      "created_at": "2026-10-19T07:08:45.407Z",
      "updated_at": "2026-10-19T08:31:51.033Z",
      "items": [
        {
          "order_item_id": "5",
          "product_id": "12",
          "product_name": "Polo Shirt Cowok Biru Dongker Kasual Blook Original",
          "product_image": "https://images.unsplash.com/photo-1717127036020-83774f354008?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=NHwxMjA3fDA%3D",
          "quantity": 1,
          "price_at_purchase": 125000,
          "subtotal": 125000
        }
      ]
    }
  }
  ```

---
