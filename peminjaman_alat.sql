-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 12 Nov 2026 pada 13.26
-- Versi server: 10.11.16-MariaDB
-- Versi PHP: 8.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Basis data: `peminjaman_alat`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_setujui_peminjaman` (IN `p_loan` BIGINT, IN `p_petugas` BIGINT)   BEGIN
                DECLARE v_tool BIGINT;
                DECLARE v_qty, v_stock INT;
                DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN ROLLBACK; RESIGNAL; END;

                START TRANSACTION;
                SELECT tool_id, quantity INTO v_tool, v_qty
                FROM loans WHERE id = p_loan AND status = 'pending' FOR UPDATE;
                SELECT stock INTO v_stock FROM tools WHERE id = v_tool FOR UPDATE;

                IF v_stock IS NULL OR v_stock < v_qty THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Stok tidak cukup / data tidak valid';
                END IF;

                UPDATE tools SET stock = stock - v_qty WHERE id = v_tool;
                UPDATE loans SET status = 'approved', approved_by = p_petugas
                WHERE id = p_loan;
                INSERT INTO activity_logs
                    (user_id, action, description, created_at, updated_at)
                VALUES (p_petugas, 'approve',
                    CONCAT('Menyetujui pinjaman #', p_loan), NOW(), NOW());
                COMMIT;
            END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_denda` (`p_due` DATE, `p_return` DATE) RETURNS INT(11) DETERMINISTIC RETURN GREATEST(DATEDIFF(p_return, p_due), 0) * 5000$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `description`, `created_at`, `updated_at`) VALUES
(1, 3, 'loan_request', 'Mengajukan pinjaman #1', '2026-11-09 22:55:44', '2026-11-09 22:55:44'),
(2, 2, 'approve', 'Menyetujui pinjaman #1', '2026-11-10 06:56:45', '2026-11-10 06:56:45'),
(3, 3, 'return', 'Pengembalian pinjaman #1', '2026-11-10 06:57:31', '2026-11-10 06:57:31'),
(4, 3, 'logout', 'Peminjam logout', '2026-11-09 23:29:37', '2026-11-09 23:29:37'),
(5, 2, 'login', 'Petugas login', '2026-11-09 23:29:51', '2026-11-09 23:29:51'),
(6, 2, 'logout', 'Petugas logout', '2026-11-09 23:30:44', '2026-11-09 23:30:44'),
(7, 1, 'login', 'Admin login', '2026-11-09 23:30:54', '2026-11-09 23:30:54'),
(8, 1, 'logout', 'Admin logout', '2026-11-09 23:36:35', '2026-11-09 23:36:35'),
(9, 3, 'login', 'Peminjam login', '2026-11-09 23:36:51', '2026-11-09 23:36:51'),
(10, 3, 'logout', 'Peminjam logout', '2026-11-09 23:39:43', '2026-11-09 23:39:43'),
(11, 2, 'login', 'Petugas login', '2026-11-09 23:39:55', '2026-11-09 23:39:55'),
(12, 2, 'logout', 'Petugas logout', '2026-11-09 23:40:05', '2026-11-09 23:40:05'),
(13, 1, 'login', 'Admin login', '2026-11-09 23:40:17', '2026-11-09 23:40:17'),
(14, 1, 'logout', 'Admin logout', '2026-11-09 23:41:04', '2026-11-09 23:41:04'),
(15, 3, 'login', 'Peminjam login', '2026-11-09 23:41:11', '2026-11-09 23:41:11'),
(16, 3, 'logout', 'Peminjam logout', '2026-11-09 23:41:34', '2026-11-09 23:41:34'),
(17, 2, 'login', 'Petugas login', '2026-11-09 23:41:41', '2026-11-09 23:41:41'),
(18, 2, 'logout', 'Petugas logout', '2026-11-09 23:42:21', '2026-11-09 23:42:21'),
(19, 1, 'login', 'Admin login', '2026-11-09 23:42:35', '2026-11-09 23:42:35'),
(20, 1, 'logout', 'Admin logout', '2026-11-10 00:52:17', '2026-11-10 00:52:17'),
(21, 2, 'login', 'Petugas login', '2026-11-10 00:52:32', '2026-11-10 00:52:32'),
(22, 2, 'logout', 'Petugas logout', '2026-11-10 01:01:57', '2026-11-10 01:01:57'),
(23, 3, 'login', 'Peminjam login', '2026-11-10 01:02:06', '2026-11-10 01:02:06'),
(24, 3, 'logout', 'Peminjam logout', '2026-11-10 01:04:21', '2026-11-10 01:04:21'),
(25, 2, 'login', 'Petugas login', '2026-11-10 01:04:42', '2026-11-10 01:04:42'),
(26, 2, 'logout', 'Petugas logout', '2026-11-10 01:08:09', '2026-11-10 01:08:09'),
(27, 1, 'login', 'Admin login', '2026-11-10 01:08:23', '2026-11-10 01:08:23'),
(28, 1, 'logout', 'Admin logout', '2026-11-10 01:12:20', '2026-11-10 01:12:20'),
(29, 3, 'login', 'Peminjam login', '2026-11-10 01:40:01', '2026-11-10 01:40:01'),
(30, 3, 'loan_request', 'Mengajukan pinjaman #2', '2026-11-10 01:40:37', '2026-11-10 01:40:37'),
(31, 3, 'logout', 'Peminjam logout', '2026-11-10 01:40:42', '2026-11-10 01:40:42'),
(32, 2, 'login', 'Petugas login', '2026-11-10 01:40:52', '2026-11-10 01:40:52'),
(33, 2, 'approve', 'Menyetujui pinjaman #2', '2026-11-10 09:41:01', '2026-11-10 09:41:01'),
(34, 2, 'logout', 'Petugas logout', '2026-11-10 01:41:06', '2026-11-10 01:41:06'),
(35, 3, 'login', 'Peminjam login', '2026-11-10 01:41:14', '2026-11-10 01:41:14'),
(36, 3, 'return', 'Pengembalian pinjaman #2', '2026-11-10 09:41:21', '2026-11-10 09:41:21'),
(37, 1, 'login', 'Admin login', '2026-11-12 01:43:47', '2026-11-12 01:43:47'),
(38, 1, 'logout', 'Admin logout', '2026-11-12 02:42:44', '2026-11-12 02:42:44'),
(39, 1, 'login', 'Admin login', '2026-11-12 02:43:11', '2026-11-12 02:43:11');

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-livewire-rate-limiter:16d36dff9abd246c67dfac3e63b993a169af77e6', 'i:1;', 1794480251),
('laravel-cache-livewire-rate-limiter:16d36dff9abd246c67dfac3e63b993a169af77e6:timer', 'i:1794480251;', 1794480251);

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Elektronik', NULL, '2026-11-09 21:55:52', '2026-11-09 21:55:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` varchar(255) NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` smallint(5) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `loans`
--

CREATE TABLE `loans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `tool_id` bigint(20) UNSIGNED NOT NULL,
  `approved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `loan_date` date NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('pending','approved','rejected','returned') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `loans`
--

INSERT INTO `loans` (`id`, `user_id`, `tool_id`, `approved_by`, `quantity`, `loan_date`, `due_date`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 2, 1, '2026-11-12', '2026-11-16', 'returned', '2026-11-09 22:55:44', '2026-11-09 22:55:44'),
(2, 3, 3, 2, 2, '2026-11-10', '2026-11-07', 'returned', '2026-11-10 01:40:37', '2026-11-10 01:40:37');

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_11_10_041332_create_categories_table', 2),
(5, '2026_11_10_041342_create_tools_table', 2),
(6, '2026_11_10_041348_create_loans_table', 2),
(7, '2026_11_10_041405_create_tool_returns_table', 2),
(8, '2026_11_10_041410_create_activity_logs_table', 2),
(9, '2026_11_10_041419_add_role_to_users_table', 2),
(10, '2026_11_10_044630_create_db_objects', 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('Qf335BaWKTLc8PjEl55dlXwCvet4yBpbkwDfAvCX', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiI2eFZyUWVRYnhNYzVMM0hYQ3pUS1dXU2lJUGxhVjNPc2k2N3VIQUFUIiwiZmlsYW1lbnQiOnsibm90aWZpY2F0aW9ucyI6eyJtYWlsYm94IjoiRkhmNVZocEN4eVNPUVF0amVHazEzSjcyT0Vodk1IWXVwTWdQS2VtNSJ9LCJ0YWJsZXMiOnsiMzkwYjRiNWE0YjBmYmIwNmQ2OTU5YjI1ODBiMmYyMWJiMzY0YzI0Yjc4YmE3NTM5NGJkZTA3OTBmZTAyNzE5ZCI6eyJjb2x1bW5zIjpbeyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6Im5hbWUiLCJsYWJlbCI6Ik5hbWUiLCJpc0hpZGRlbiI6ZmFsc2UsImlzVG9nZ2xlZCI6dHJ1ZSwiaXNUb2dnbGVhYmxlIjpmYWxzZSwiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjpudWxsfSx7InR5cGUiOiJjb2x1bW4iLCJuYW1lIjoiY3JlYXRlZF9hdCIsImxhYmVsIjoiQ3JlYXRlZCBhdCIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjpmYWxzZSwiaXNUb2dnbGVhYmxlIjp0cnVlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOnRydWV9LHsidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJ1cGRhdGVkX2F0IiwibGFiZWwiOiJVcGRhdGVkIGF0IiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOmZhbHNlLCJpc1RvZ2dsZWFibGUiOnRydWUsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6dHJ1ZX1dfSwiZjI5NWI4OGRlOWViNTNhNDc4OGI5NjFjMjBjNTBmZDQ1Yzg5OGRmMzdmZTJjMTFjOThiNjlkMWNkODRkNjlmNiI6eyJjb2x1bW5zIjpbeyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImNhdGVnb3J5Lm5hbWUiLCJsYWJlbCI6IkthdGVnb3JpIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6Im5hbWUiLCJsYWJlbCI6Ik5hbWEgQWxhdCIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjp0cnVlLCJpc1RvZ2dsZWFibGUiOmZhbHNlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOm51bGx9LHsidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJjb2RlIiwibGFiZWwiOiJLb2RlIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6InN0b2NrIiwibGFiZWwiOiJTdG9rIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImNvbmRpdGlvbiIsImxhYmVsIjoiS29uZGlzaSIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjp0cnVlLCJpc1RvZ2dsZWFibGUiOmZhbHNlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOm51bGx9LHsidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJpc19hY3RpdmUiLCJsYWJlbCI6IkFrdGlmIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH1dfSwiODkwNjdiM2I1MjA3YzFlZGZlZmI1Mzg3YzEyNjMwMTcxOTg4OGI4NzNjZTJlYzBhZDQzYzlhYzAyZDFmYTMwMSI6eyJjb2x1bW5zIjpbeyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6InVzZXIubmFtZSIsImxhYmVsIjoiUGVtaW5qYW0iLCJpc0hpZGRlbiI6ZmFsc2UsImlzVG9nZ2xlZCI6dHJ1ZSwiaXNUb2dnbGVhYmxlIjpmYWxzZSwiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjpudWxsfSx7InR5cGUiOiJjb2x1bW4iLCJuYW1lIjoidG9vbC5uYW1lIiwibGFiZWwiOiJBbGF0IiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6InF1YW50aXR5IiwibGFiZWwiOiJKdW1sYWgiLCJpc0hpZGRlbiI6ZmFsc2UsImlzVG9nZ2xlZCI6dHJ1ZSwiaXNUb2dnbGVhYmxlIjpmYWxzZSwiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjpudWxsfSx7InR5cGUiOiJjb2x1bW4iLCJuYW1lIjoibG9hbl9kYXRlIiwibGFiZWwiOiJUZ2wgUGluamFtIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImR1ZV9kYXRlIiwibGFiZWwiOiJKYXR1aCBUZW1wbyIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjp0cnVlLCJpc1RvZ2dsZWFibGUiOmZhbHNlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOm51bGx9LHsidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJzdGF0dXMiLCJsYWJlbCI6IlN0YXR1cyIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjp0cnVlLCJpc1RvZ2dsZWFibGUiOmZhbHNlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOm51bGx9XX0sImU4NTgzYTFlYjQ1OWRjNTc2NjliYTE0OTQ1MTc5MzY3YzE5ZTYzNDRmZDJmZmU4MWJmYTU0OTRkNmFjY2QyNWQiOnsiY29sdW1ucyI6W3sidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJsb2FuX2lkIiwibGFiZWwiOiJMb2FuIGlkIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6InJldHVybmVkX2F0IiwibGFiZWwiOiJSZXR1cm5lZCBhdCIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjp0cnVlLCJpc1RvZ2dsZWFibGUiOmZhbHNlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOm51bGx9LHsidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJsYXRlX2RheXMiLCJsYWJlbCI6IkxhdGUgZGF5cyIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjp0cnVlLCJpc1RvZ2dsZWFibGUiOmZhbHNlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOm51bGx9LHsidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJmaW5lIiwibGFiZWwiOiJGaW5lIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImNvbmRpdGlvbiIsImxhYmVsIjoiQ29uZGl0aW9uIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImNyZWF0ZWRfYXQiLCJsYWJlbCI6IkNyZWF0ZWQgYXQiLCJpc0hpZGRlbiI6ZmFsc2UsImlzVG9nZ2xlZCI6ZmFsc2UsImlzVG9nZ2xlYWJsZSI6dHJ1ZSwiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0Ijp0cnVlfSx7InR5cGUiOiJjb2x1bW4iLCJuYW1lIjoidXBkYXRlZF9hdCIsImxhYmVsIjoiVXBkYXRlZCBhdCIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjpmYWxzZSwiaXNUb2dnbGVhYmxlIjp0cnVlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOnRydWV9XX0sIjI3NjQ4M2VhYTYwMjhlMTQ2YTMyMjRiZGUxODE0NjFmYzcxM2M1NTFmZGNiOGM4NDZmMWY4YmE2ZTQ2MDllOTgiOnsiY29sdW1ucyI6W3sidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJuYW1lIiwibGFiZWwiOiJOYW1lIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImVtYWlsIiwibGFiZWwiOiJFbWFpbCBhZGRyZXNzIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6InJvbGUiLCJsYWJlbCI6IlJvbGUiLCJpc0hpZGRlbiI6ZmFsc2UsImlzVG9nZ2xlZCI6dHJ1ZSwiaXNUb2dnbGVhYmxlIjpmYWxzZSwiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjpudWxsfSx7InR5cGUiOiJjb2x1bW4iLCJuYW1lIjoiZW1haWxfdmVyaWZpZWRfYXQiLCJsYWJlbCI6IkVtYWlsIHZlcmlmaWVkIGF0IiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImNyZWF0ZWRfYXQiLCJsYWJlbCI6IkNyZWF0ZWQgYXQiLCJpc0hpZGRlbiI6ZmFsc2UsImlzVG9nZ2xlZCI6ZmFsc2UsImlzVG9nZ2xlYWJsZSI6dHJ1ZSwiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0Ijp0cnVlfSx7InR5cGUiOiJjb2x1bW4iLCJuYW1lIjoidXBkYXRlZF9hdCIsImxhYmVsIjoiVXBkYXRlZCBhdCIsImlzSGlkZGVuIjpmYWxzZSwiaXNUb2dnbGVkIjpmYWxzZSwiaXNUb2dnbGVhYmxlIjp0cnVlLCJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiOnRydWV9XX0sIjhkZGY4OTdkMjE5ZjY1MDdjZWJjMDY0MDNlNjUyM2Y1NmJhODQxM2RmNThmZjQxZGJkMzJlOGRjM2QzZWNiZGIiOnsiY29sdW1ucyI6W3sidHlwZSI6ImNvbHVtbiIsIm5hbWUiOiJ1c2VyLm5hbWUiLCJsYWJlbCI6IlVzZXIiLCJpc0hpZGRlbiI6ZmFsc2UsImlzVG9nZ2xlZCI6dHJ1ZSwiaXNUb2dnbGVhYmxlIjpmYWxzZSwiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjpudWxsfSx7InR5cGUiOiJjb2x1bW4iLCJuYW1lIjoiYWN0aW9uIiwibGFiZWwiOiJBa3NpIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImRlc2NyaXB0aW9uIiwibGFiZWwiOiJLZXRlcmFuZ2FuIiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH0seyJ0eXBlIjoiY29sdW1uIiwibmFtZSI6ImNyZWF0ZWRfYXQiLCJsYWJlbCI6Ildha3R1IiwiaXNIaWRkZW4iOmZhbHNlLCJpc1RvZ2dsZWQiOnRydWUsImlzVG9nZ2xlYWJsZSI6ZmFsc2UsImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI6bnVsbH1dfX19LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX0sIl9wcmV2aW91cyI6eyJ1cmwiOiJodHRwOlwvXC8xMjcuMC4wLjE6ODAwMFwvYWRtaW5cL3Rvb2xzIiwicm91dGUiOiJmaWxhbWVudC5hZG1pbi5yZXNvdXJjZXMudG9vbHMuaW5kZXgifSwibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiOjEsInBhc3N3b3JkX2hhc2hfd2ViIjoiNTY3MTg4YWE3ZTU2NmRkZGNhNDBlM2IyMTM2ZWM2NmM2MjRlNDcwYzViOTMyZjNlNzAzMGJhNGEwMDNlZTk2YiJ9', 1794483657);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tools`
--

CREATE TABLE `tools` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `stock` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `condition` varchar(255) NOT NULL DEFAULT 'good',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `tools`
--

INSERT INTO `tools` (`id`, `category_id`, `name`, `code`, `stock`, `condition`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'komputer', '1150', 6, 'good', 1, '2026-11-09 21:57:33', '2026-11-09 21:57:33'),
(2, 1, 'Osiloskop', '1151', 12, 'good', 1, '2026-11-10 01:09:09', '2026-11-10 01:09:09'),
(3, 1, 'Multimeter ', '1152', 7, 'good', 1, '2026-11-10 01:09:46', '2026-11-10 01:09:46'),
(4, 1, 'Stasiun Solder ', '1153', 5, 'good', 1, '2026-11-10 01:10:23', '2026-11-10 01:10:23'),
(5, 1, 'Breadboard & Jumper Wires:', '1154', 10, 'good', 1, '2026-11-10 01:11:00', '2026-11-10 01:11:00'),
(6, 1, 'Trainer Kit ', '1155', 5, 'good', 1, '2026-11-10 01:11:39', '2026-11-10 01:11:39');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tool_returns`
--

CREATE TABLE `tool_returns` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `loan_id` bigint(20) UNSIGNED NOT NULL,
  `returned_at` datetime NOT NULL,
  `late_days` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `fine` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `condition` varchar(255) NOT NULL DEFAULT 'good',
  `note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `tool_returns`
--

INSERT INTO `tool_returns` (`id`, `loan_id`, `returned_at`, `late_days`, `fine`, `condition`, `note`, `created_at`, `updated_at`) VALUES
(1, 1, '2026-11-10 06:57:31', 0, 0, 'good', NULL, '2026-11-09 22:57:31', '2026-11-09 22:57:31'),
(2, 2, '2026-11-10 09:41:21', 3, 15000, 'good', NULL, '2026-11-10 01:41:21', '2026-11-10 01:41:21');

--
-- Trigger `tool_returns`
--
DELIMITER $$
CREATE TRIGGER `trg_return_after_insert` AFTER INSERT ON `tool_returns` FOR EACH ROW BEGIN
                UPDATE loans SET status = 'returned' WHERE id = NEW.loan_id;
                UPDATE tools t JOIN loans l ON l.tool_id = t.id
                SET t.stock = t.stock + l.quantity
                WHERE l.id = NEW.loan_id;
                INSERT INTO activity_logs
                    (user_id, action, description, created_at, updated_at)
                SELECT user_id, 'return',
                    CONCAT('Pengembalian pinjaman #', NEW.loan_id), NOW(), NOW()
                FROM loans WHERE id = NEW.loan_id;
            END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` enum('admin','petugas','peminjam') NOT NULL DEFAULT 'peminjam',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `role`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@mail.com', 'admin', NULL, '$2y$12$SDewmcw/mcRdetSuOLIRHejEYPHRneIpT5OL.NWf0Z.3TqbAM/0Pm', NULL, '2026-11-09 20:45:13', '2026-11-09 20:45:13'),
(2, 'Petugas', 'petugas@mail.com', 'petugas', NULL, '$2y$12$VlV0e5tGB5X7iEeLenk8qOciu8z3yEJY/7VpPLvrvg46aaoWOusK6', NULL, '2026-11-09 20:45:13', '2026-11-09 20:45:13'),
(3, 'Peminjam', 'peminjam@mail.com', 'peminjam', NULL, '$2y$12$EoroKbG/ZnxXsIB7lk6SueajmhBVV3uqVLrTzBssJqoQ49L8M8/iu', NULL, '2026-11-09 20:45:13', '2026-11-09 20:45:13');

--
-- Indeks untuk tabel yang dibuang
--

--
-- Indeks untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activity_logs_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  ADD KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loans_user_id_foreign` (`user_id`),
  ADD KEY `loans_tool_id_foreign` (`tool_id`),
  ADD KEY `loans_approved_by_foreign` (`approved_by`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `tools`
--
ALTER TABLE `tools`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tools_code_unique` (`code`),
  ADD KEY `tools_category_id_foreign` (`category_id`);

--
-- Indeks untuk tabel `tool_returns`
--
ALTER TABLE `tool_returns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tool_returns_loan_id_unique` (`loan_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `loans`
--
ALTER TABLE `loans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `tools`
--
ALTER TABLE `tools`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `tool_returns`
--
ALTER TABLE `tool_returns`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `loans_tool_id_foreign` FOREIGN KEY (`tool_id`) REFERENCES `tools` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loans_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tools`
--
ALTER TABLE `tools`
  ADD CONSTRAINT `tools_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tool_returns`
--
ALTER TABLE `tool_returns`
  ADD CONSTRAINT `tool_returns_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
