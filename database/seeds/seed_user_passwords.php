<?php

/**
 * Database seed: set Welcome@123 for all active user_master accounts.
 *
 * Usage (from project root):
 *   php database/seeds/seed_user_passwords.php
 *
 * Uses password_hash(PASSWORD_DEFAULT) via includes/password_security_helpers.php.
 * Plain password is never stored in the database.
 */

declare(strict_types=1);

$projectRoot = dirname(__DIR__, 2);

require $projectRoot . '/pdo_obconn.php';
require $projectRoot . '/includes/password_security_helpers.php';

const SEED_USER_PASSWORD = 'Welcome@123';

$passwordHash = user_password_hash(SEED_USER_PASSWORD);

$stmt = $obconn->prepare('
    UPDATE user_master
    SET password = :password,
        updated_at = CURRENT_TIMESTAMP
    WHERE deleted_at IS NULL
');
$stmt->bindValue(':password', $passwordHash);
$stmt->execute();

$updatedCount = $stmt->rowCount();
$activeCount = (int) $obconn
    ->query('SELECT COUNT(*) FROM user_master WHERE deleted_at IS NULL')
    ->fetchColumn();

echo "Seed completed: seed_user_passwords\n";
echo 'Password set for all active users: ' . SEED_USER_PASSWORD . "\n";
echo 'Users updated: ' . $updatedCount . "\n";
echo 'Active users in database: ' . $activeCount . "\n";

if (!user_password_verify(SEED_USER_PASSWORD, $passwordHash)) {
    fwrite(STDERR, "Warning: generated hash failed verification.\n");
    exit(1);
}

exit(0);
