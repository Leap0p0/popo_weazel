INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_weazel','weazel',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_weazel','weazel',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_weazel', 'weazel', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('weazel','Weazel News')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('weazel',0,'recruit','Recrue',10,'{}','{}'),
	('weazel',1,'novice','Novice',25,'{}','{}'),
	('weazel',2,'experienced','Experimente',40,'{}','{}'),
	('weazel',3,'boss','Patron',0,'{}','{}')
;
