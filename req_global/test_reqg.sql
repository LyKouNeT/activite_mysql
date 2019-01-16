-- Test pour la l'amélioration 1 pour le calcul du nombre de commentaire

PREPARE select_article_nbre_commentaire
FROM 
'SELECT Article.id,
	VM_article_nbre_commentaire.nombre_commentaires
FROM Article
INNER JOIN VM_article_nbre_commentaire
	ON Article.id = VM_article_nbre_commentaire.article_id
	ORDER BY id ASC';

EXECUTE select_article_nbre_commentaire;

SELECT "On insert un commentaire sur article id = 1";

INSERT INTO Commentaire(article_id, auteur_id, contenu, date_commentaire)
VALUES(1, 4, 'yolo', NOW());

EXECUTE select_article_nbre_commentaire;

SELECT "On delete le dernier commentaire inséré sur article id = 1";

DELETE FROM Commentaire
WHERE id = LAST_INSERT_ID();

EXECUTE select_article_nbre_commentaire;

SELECT "On insert un nouvel article";

INSERT INTO Article(titre, resume, contenu, auteur_id, date_publication)
VALUES('test', 'ahah', 'yolo', 1, NOW());

EXECUTE select_article_nbre_commentaire;

SELECT "On insert un commentaire sur le dernier article inséré";

INSERT INTO Commentaire(article_id, auteur_id, contenu, date_commentaire)
VALUES(LAST_INSERT_ID(), 4, 'yolo', NOW());

EXECUTE select_article_nbre_commentaire;

SELECT "On delete le dernier commentaire inséré";

DELETE FROM Commentaire
WHERE id = LAST_INSERT_ID();

EXECUTE select_article_nbre_commentaire;

SELECT "Derniere chose à faire : delete le dernier article";

-- Test pour l'amélioration 2
-- On insert un article sans résumé.

SELECT "On insert un nouvel article sans résumé";

INSERT INTO Article(titre, contenu, auteur_id, date_publication)
VALUES('test', 'yolo', 1, NOW());

SELECT "On verifie que le dernier article a un résumé grace au trigger";

SELECT * FROM Article WHERE id = LAST_INSERT_ID();

SELECT "On essaie de mettre le résumé à NULL";

UPDATE Article
SET resume = NULL
WHERE id = LAST_INSERT_ID();

SELECT * FROM Article WHERE id = LAST_INSERT_ID();
     
SELECT "Todo : delete l'article"

-- Test pour amélioration 3
