-- We insert a Article without resume. 
INSERT INTO Article(titre, contenu, auteur_id, date_publication)
VALUES('test', 'yolo', 1, NOW());

SELECT * FROM Article WHERE id = LAST_INSERT_ID();

UPDATE Article
SET resume = NULL
WHERE id = LAST_INSERT_ID();

SELECT * FROM Article WHERE id = LAST_INSERT_ID();


-- DELETE FROM Article
-- WHERE id = LAST_INSERT_ID();

