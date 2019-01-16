SELECT Commentaire.id AS commentaire_id,
	Article.id AS article_id
FROM Commentaire
RIGHT JOIN Article
	ON Commentaire.article_id = Article.id
-- WHERE Commentaire.id IS NULL
GROUP BY article_id WITH ROLLUP;
-- ORDER BY article_id;

-- SELECT Article.id AS article_id,
--  	Commentaire.id AS commentaire_id
-- FROM Article
-- LEFT OUTER JOIN Commentaire
-- 	ON Article.id = Commentaire.article_id
-- GROUP BY article_id
-- ORDER BY article_id, commentaire_id;
-- 
-- SELECT Article.id AS article_id,
--  	COUNT(Commentaire.id) AS nombre_article
-- FROM Article
-- LEFT OUTER JOIN Commentaire
-- 	ON Article.id = Commentaire.article_id
-- -- GROUP BY article_id
-- ORDER BY article_id;

-- SELECT U.id AS Auteur_id
-- -- 	A.id as nombre_article
-- -- 	A.date_publication as date_dernier_article
-- --	VM_anc.nombre_commentaires,
-- -- 	C.date_commentaire
-- FROM Article AS A
-- INNER JOIN Utilisateur AS U
-- 	ON A.auteur_id = U.id
-- LEFT OUTER JOIN VM_article_nbre_commentaire AS VM_anc
-- 	ON A.id = VM_anc.article_id
-- LEFT OUTER JOIN Commentaire AS C
-- 	ON A.id = C.article_id
-- ORDER BY U.id;
-- 
-- 
-- -- SELECT U.id AS Auteur_id,
-- -- 	COUNT(DISTINCT A.id) as nombre_article,
-- -- 	MAX(A.date_publication) as date_dernier_article,
-- -- 	VM_anc.nombre_commentaires,
-- -- 	MAX(C.date_commentaire)
-- -- FROM Article AS A
-- -- INNER JOIN Utilisateur AS U
-- -- 	ON A.auteur_id = U.id
-- -- INNER JOIN VM_article_nbre_commentaire AS VM_anc
-- -- 	ON A.id = VM_anc.article_id
-- -- LEFT OUTER JOIN Commentaire AS C
-- -- 	ON A.id = C.article_id
-- -- GROUP BY U.id;
