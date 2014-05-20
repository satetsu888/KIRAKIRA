USE kirakira;
DROP TABLE IF EXISTS kirakira_map;
CREATE TABLE `kirakira_map` (
    `hash` varchar(32) NOT NULL default '',
    `word` text,
    `create_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
    PRIMARY KEY  (`hash`),
    KEY `create_at` (`create_at`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8
