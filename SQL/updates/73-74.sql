-- GS13 character weight preferences.
ALTER TABLE `characters`
  ADD COLUMN `gs13_preferences` LONGTEXT COLLATE 'utf8mb4_unicode_ci' DEFAULT NULL AFTER `quirks`;
