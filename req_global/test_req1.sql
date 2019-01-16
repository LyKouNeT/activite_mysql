-- Test pour la première requête pour le calcul du nombre de commentaire

PREPARE select_article_nbre_commentaire
FROM 
'SELECT Article.id,
	VM_article_nbre_commentaire.nombre_commentaires
FROM Article
INNER JOIN VM_article_nbre_commentaire
	ON Article.id = VM_article_nbre_commentaire.article_id
	ORDER BY id ASC';

EXECUTE select_article_nbre_commentaire;

INSERT INTO Commentaire(article_id, auteur_id, contenu, date_commentaire)
VALUES(1, 4, 'yolo', NOW());

EXECUTE select_article_nbre_commentaire;

DELETE FROM Commentaire
WHERE id = LAST_INSERT_ID();

EXECUTE select_article_nbre_commentaire;

INSERT INTO Article(titre, resume, contenu, auteur_id, date_publication)
VALUES('test', 'ahah', 'yolo', 1, NOW());

EXECUTE select_article_nbre_commentaire;

INSERT INTO Commentaire(article_id, auteur_id, contenu, date_commentaire)
VALUES(LAST_INSERT_ID(), 4, 'yolo', NOW());

EXECUTE select_article_nbre_commentaire;
