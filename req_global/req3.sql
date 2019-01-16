DROP TABLE IF EXISTS VM_utilisateur_article;

CREATE TABLE VM_utilisateur_article  
SELECT Utilisateur.id AS utilisateur_id,
	COUNT(Article.id) AS nombre_article
FROM Article
INNER JOIN Utilisateur
	ON Article.auteur_id = Utilisateur.id
GROUP BY utilisateur_id
ORDER BY utilisateur_id;

SELECT Utilisateur.id AS utilisateur_id,
--	Article.id AS article_id,
	SUM(VM_article_nbre_commentaire.nombre_commentaires)
FROM Utilisateur
-- RIGHT OUTER JOIN Article
INNER JOIN Article
	ON Article.auteur_id = Utilisateur.id
INNER JOIN VM_article_nbre_commentaire
	ON Article.id = VM_article_nbre_commentaire.article_id
-- GROUP BY utilisateur_id, article_id;
GROUP BY utilisateur_id;

-- SELECT Utilisateur.id AS utilisateur_id,
-- 	VM_utilisateur_article.nombre_article,
--   	MAX(Article.date_publication) as date_dernier_article,
--  	VM_article_nbre_commentaire.nombre_commentaires
-- -- 	MAX(Commentaire.date_commentaire) AS date_dernier_commentaire
-- FROM Utilisateur
-- INNER JOIN VM_utilisateur_article
-- 	ON Utilisateur.id = VM_utilisateur_article.utilisateur_id
-- INNER JOIN Article 
-- 	ON Utilisateur.id = Article.auteur_id
--  INNER JOIN VM_article_nbre_commentaire
--  	ON Article.id = VM_article_nbre_commentaire.article_id;

-- LEFT OUTER JOIN Commentaire
-- 	ON Article.id = Commentaire.article_id;
-- GROUP BY Utilisateur.id;
	
-- SELECT Article.id as article_id,
-- 	COALESCE(VM_article_nbre_commentaire.nombre_commentaires, 0) AS nombre_commentaires
-- FROM Article
-- LEFT OUTER JOIN VM_article_nbre_commentaire
-- 	ON Article.id = VM_article_nbre_commentaire.article_id
-- GROUP BY article_id;


-- Consignes : 
-- Enfin, les administrateurs du site veulent 
-- connaître quelques statistiques sur les 
-- utilisateurs enregistrés : 
-- le nombre d’articles écrits,
-- la date du dernier article, 
-- le nombre de commentaires écrits 
-- et la date du dernier commentaire. 
-- Ces informations doivent être stockées pour 
-- ne pas devoir les recalculer chaque fois. 
-- Par contre, elles ne doivent pas nécessairement 
-- être à jour à tout moment. On doit disposer d’un 
-- outil pour faire les mises à jour à la demande.

-- Va pour une Vue matérialisé avec une procedure pour la mettre à jour !



-- -- CREATE TABLE VM_utilisateur_stat
-- SELECT COUNT(Article.id) as nombre_article,
-- 	MAX(Article.date_publication) as date_dernier_article,
-- 	VM_anc.nombre_commentaires,
-- -- 	(SELECT ) AS date_dernier_commentaire	
-- FROM Article AS A
-- INNER JOIN Utilisateur AS U
-- 	ON A.auteur_id = U.id
-- INNER JOIN VM_article_nbre_commentaire AS VM_anc
-- 	ON A.id = VM_anc.article_id
-- GROUP BY Utilisateur.id;
