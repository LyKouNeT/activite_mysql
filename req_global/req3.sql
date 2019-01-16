-- Table pour avoir le nombre d'articles
-- en fonction de l'utilisateur.
DROP TABLE IF EXISTS VM_utilisateur_nbre_article;
CREATE TABLE VM_utilisateur_nbre_article  
SELECT Utilisateur.id AS utilisateur_id,
	COUNT(Article.id) AS nombre_article
FROM Article
INNER JOIN Utilisateur
	ON Article.auteur_id = Utilisateur.id
GROUP BY utilisateur_id
ORDER BY utilisateur_id;

-- -- Je cherche à avoir le nombre de commentaire écrit par utilisateur.
-- SELECT Utilisateur.id AS utilisateur_id,
-- --	Article.id AS article_id,
-- 	SUM(VM_article_nbre_commentaire.nombre_commentaires)
-- FROM Utilisateur
-- INNER JOIN Article
-- 	ON Article.auteur_id = Utilisateur.id
-- INNER JOIN VM_article_nbre_commentaire
-- 	ON Article.id = VM_article_nbre_commentaire.article_id
-- -- GROUP BY utilisateur_id, article_id;
-- GROUP BY utilisateur_id;

-- Test où j'essaie d'abord d'avoir toutes 
-- les informations.
SELECT Utilisateur.id AS utilisateur_id,
	Article.date_publication,
	VM_utilisateur_nbre_article.nombre_article AS nombre_article_ecris,
	Commentaire.id,
	Commentaire.date_commentaire
FROM Utilisateur
INNER JOIN VM_utilisateur_nbre_article
 	ON Utilisateur.id = VM_utilisateur_nbre_article.utilisateur_id
INNER JOIN Article
 	ON Utilisateur.id = Article.auteur_id
LEFT OUTER JOIN Commentaire 
 	ON Utilisateur.id = Commentaire.auteur_id
ORDER BY utilisateur_id ASC, Article.date_publication DESC;

-- -- Test où j'essaie d'avoir la table 
-- -- avec uniquement les infos voulu
SELECT Utilisateur.id AS utilisateur_id,
	MAX(Article.date_publication) AS date_dernier_article,
	VM_utilisateur_nbre_article.nombre_article AS nombre_articles_ecris,
	COUNT(Commentaire.id) AS nombre_commentaires_ecris,
	MAX(Commentaire.date_commentaire) AS date_dernier_commentaire
FROM Utilisateur
INNER JOIN VM_utilisateur_nbre_article
 	ON Utilisateur.id = VM_utilisateur_nbre_article.utilisateur_id
INNER JOIN Article
 	ON Utilisateur.id = Article.auteur_id
LEFT OUTER JOIN Commentaire 
 	ON Utilisateur.id = Commentaire.auteur_id
GROUP BY utilisateur_id
ORDER BY utilisateur_id;














