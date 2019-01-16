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

-- Je cherche à avoir le nombre de commentaire écrit par utilisateur.
DROP TABLE IF EXISTS VM_utilisateur_commentaire;

CREATE TABLE VM_utilisateur_commentaire
SELECT 	Utilisateur.id AS utilisateur_id,
	COUNT(Commentaire.id) AS nombre_commentaires_ecris,
	MAX(Commentaire.date_commentaire) AS date_publication_dernier_commentaire
FROM Commentaire
INNER JOIN Utilisateur
	ON Commentaire.auteur_id = Utilisateur.id
GROUP BY utilisateur_id
ORDER BY utilisateur_id;

SELECT * FROM VM_utilisateur_commentaire;


-- Test où j'essaie d'abord d'avoir toutes 
-- les informations.
-- J'ai un doute sur la pertinance du nombre de commentaire
-- Je dois vérifier cela 
SELECT Utilisateur.id AS utilisateur_id,
	Article.date_publication,
	VM_utilisateur_nbre_article.nombre_article AS nombre_article_ecris,
	VM_utilisateur_commentaire.nombre_commentaires_ecris AS nombre_commentaires_ecris,
	VM_utilisateur_commentaire.date_publication_dernier_commentaire
FROM Utilisateur
INNER JOIN Article
 	ON Utilisateur.id = Article.auteur_id
INNER JOIN VM_utilisateur_nbre_article
 	ON Utilisateur.id = VM_utilisateur_nbre_article.utilisateur_id
LEFT OUTER JOIN VM_utilisateur_commentaire
	ON Utilisateur.id = VM_utilisateur_commentaire.utilisateur_id
ORDER BY utilisateur_id ASC, Article.date_publication DESC;


-- Cette version fonctionne
SELECT Utilisateur.id AS utilisateur_id,
	MAX(Article.date_publication) AS date_publication_dernier_article,
	VM_utilisateur_nbre_article.nombre_article AS nombre_article_ecris,
	VM_utilisateur_commentaire.nombre_commentaires_ecris AS nombre_commentaires_ecris,
	VM_utilisateur_commentaire.date_publication_dernier_commentaire
FROM Utilisateur
INNER JOIN Article
 	ON Utilisateur.id = Article.auteur_id
INNER JOIN VM_utilisateur_nbre_article
 	ON Utilisateur.id = VM_utilisateur_nbre_article.utilisateur_id
LEFT OUTER JOIN VM_utilisateur_commentaire
	ON Utilisateur.id = VM_utilisateur_commentaire.utilisateur_id
GROUP BY utilisateur_id, nombre_article_ecris, nombre_commentaires_ecris, date_publication_dernier_commentaire
ORDER BY utilisateur_id ASC, Article.date_publication DESC;
