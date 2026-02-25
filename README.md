🚀 E-Commerce Data Pipeline: n8n & dbt Orchestration

Bu proje, ham verilerin PostgreSQL'den MSSQL'e taşınmasını (EL), n8n ile orkestre edilmesini ve dbt kullanılarak işlenip analize hazır hale getirilmesini (T) kapsayan uçtan uca bir veri hattı (Data Pipeline) çalışmasıdır.

🛠 Kullanılan Teknolojiler

Source DB: PostgreSQL (Docker üzerinde)

Orchestration: n8n (Docker üzerinde)

Transformation Tool: dbt (Data Build Tool)

Target DWH: Microsoft SQL Server (MSSQL)

Infrastructure: Docker & Docker Compose

🏗 Mimari Yapı (Data Flow)
1️⃣ Extraction (Çıkarma)

n8n, Docker üzerindeki PostgreSQL veritabanına bağlanır ve ham e-ticaret verilerini (users, orders, events) çeker.

2️⃣ Loading (Yükleme)

Çekilen veriler, herhangi bir işlem görmeden MSSQL üzerindeki ecommerce_dwh veritabanında "raw" (ham) tablolara aktarılır.

3️⃣ Transformation (Dönüşüm - dbt)
🔹 Silver Layer

Veri tipleri düzeltilir (TRY_CAST)

Tarih formatları normalize edilir

Null değerler temizlenir

🔹 Gold Layer

Temizlenen tablolar JOIN edilerek işletme değerine sahip final tablolar oluşturulur (örneğin: fct_vip_customers).

4️⃣ Automation

Tüm süreç n8n üzerinden tetiklenerek tam otomatize bir akış sağlanır.

📂 Proje Klasör Yapısı
.
├── dbt_project/                 # dbt modelleri ve konfigürasyonları
│   ├── models/
│   │   ├── staging/             # Silver Layer: İlk temizlik modelleri
│   │   └── marts/               # Gold Layer: İş analizi modelleri
│   └── dbt_project.yml
├── docker-compose.yml           # n8n ve PostgreSQL konteyner ayarları
└── README.md
🚀 Kurulum ve Çalıştırma
1️⃣ Veritabanlarını Hazırlayın

Docker Compose'u başlatarak PostgreSQL ve n8n'i ayağa kaldırın:

docker-compose up -d
2️⃣ dbt Profilini Ayarlayın

~/.dbt/profiles.yml dosyanızda MSSQL bağlantı ayarlarının yapıldığından emin olun:

ecommerce_dbt:
  outputs:
    dev:
      type: sqlserver
      driver: 'ODBC Driver 17 for SQL Server'
      host: localhost
      port: 1433
      user: your_user
      pass: your_password
      database: ecommerce_dwh
      schema: dbo
  target: dev
3️⃣ Hattı Çalıştırın

n8n üzerinden workflow'u başlatın (Postgres → MSSQL aktarımı).

Ardından terminalden veya n8n tetikleyicisi ile dbt'yi çalıştırın:

dbt run
