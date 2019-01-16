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



-- CREATE TABLE VM_utilisateur_stat
SELECT COUNT(Article.id) as nombre_article,
	MAX(Article.date_publication) as date_dernier_article,
	VM_anc.nombre_commentaires,
-- 	(SELECT ) AS date_dernier_commentaire	
FROM Article AS A
INNER JOIN Utilisateur AS U
	ON A.auteur_id = U.id
INNER JOIN VM_article_nbre_commentaire AS VM_anc
	ON A.id = VM_anc.article_id
GROUP BY Utilisateur.id;
