drop table if EXISTS wy1;

CREATE TABLE `wy1` (
  `code` char(8) NOT NULL,
  `dt` date NOT NULL,
  `oc` mediumint(8) unsigned NOT NULL,
  `vos` int(10) unsigned DEFAULT NULL,
  `cos` int(10) unsigned DEFAULT NULL,
  `nc` mediumint(8) unsigned NOT NULL,
  `vns` int(10) unsigned DEFAULT NULL,
  `cns` int(10) unsigned DEFAULT NULL,
  `ic` mediumint(8) unsigned NOT NULL,
  `vis` int(10) unsigned DEFAULT NULL,
  `cis` int(10) unsigned DEFAULT NULL,
  `H_pri` decimal(7,2) DEFAULT NULL,
  `L_pri` decimal(7,2) DEFAULT NULL,
  `fir_pri` decimal(7,2) DEFAULT NULL,
  `fir_tm` time DEFAULT NULL,
  `last_pri` decimal(7,2) DEFAULT NULL,
  `last_tm` time DEFAULT NULL,
  PRIMARY KEY (`code`,`dt`)
) 
ENGINE=MyISAM DEFAULT CHARSET=utf8 
ROW_FORMAT=COMPRESSED  
KEY_BLOCK_SIZE=8;
