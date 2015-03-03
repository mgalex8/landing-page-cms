ALTER TABLE `stats_installs` CHANGE `amount_installs` `amount_installs_chrome` INT( 11 ) UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE `stats_installs` DROP `amount_uninstalls`;
ALTER TABLE `stats_installs` ADD `amount_installs_firefox` INT UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE `stats_installs` ADD `amount_installs_ie` INT UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE `stats_installs` ADD `amount_installs_unknown` INT UNSIGNED NOT NULL DEFAULT '0';