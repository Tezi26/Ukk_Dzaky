<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // (1) FUNCTION: hitung denda
        DB::unprepared("
            CREATE FUNCTION hitung_denda(p_due DATE, p_return DATE)
            RETURNS INT DETERMINISTIC
            RETURN GREATEST(DATEDIFF(p_return, p_due), 0) * 5000
        ");

        // (2) STORED PROCEDURE: setujui peminjaman
        DB::unprepared("
            CREATE PROCEDURE sp_setujui_peminjaman(IN p_loan BIGINT, IN p_petugas BIGINT)
            BEGIN
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
            END
        ");

        // (3) TRIGGER: otomatis saat ada data pengembalian
        DB::unprepared("
            CREATE TRIGGER trg_return_after_insert AFTER INSERT ON tool_returns
            FOR EACH ROW
            BEGIN
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
        ");
    }

    public function down(): void
    {
        DB::unprepared('DROP TRIGGER IF EXISTS trg_return_after_insert');
        DB::unprepared('DROP PROCEDURE IF EXISTS sp_setujui_peminjaman');
        DB::unprepared('DROP FUNCTION IF EXISTS hitung_denda');
    }
};