-- !!!!!! Il y a un probleme sur la VM_article_nbre_commentaire
-- il manque l'article 7.
-- VOIR test_req3.sql pour tenter de trouver une solution.

-- Amélioration 1
-- Consignes :
-- Sur la page d’accueil, on affiche le nombre 
-- de commentaires de chaque article. 
-- On veut éviter de calculer cela à chaque 
-- affichage de la page. Il faut donc stocker
-- ce nombre quelque part, et automatiser sa 
-- mise à jour afin que l’information soit toujours exacte.

-- On stocke le nombre de commentaire par 
-- article dans la vue matérialisée VM_article_nbre_commentaire.
-- REMARQUE IMPORTANTE : 
-- Pour une raison qui m'échappe,
-- "GROUP BY article_id" va faire disparaitre l'article avec id = 7 !
-- C'est pour cette raison que je crée VM_preleminaire.
-- Cette dernière n'aura pas de ligne pour article_id = 7.
-- Ensuite je crée VM_article_nbre_commentaire : 
-- je joins Article par la gauche avec VM_preleminaire
-- et je prends soin de mettre un COAlESCE sur la colonne nombre_commentaire.
-- VM_article_nbre_commentaire possède ainsi 
-- tous les id d'article et leurs nombres de commentaire associés.

CREATE TABLE VM_preleminaire
	ENGINE = InnoDB
	SELECT Article.id as article_id,
		COUNT(Commentaire.id) AS nombre_commentaires
	FROM Article
	LEFT OUTER JOIN Commentaire
		ON Article.id = Commentaire.article_id
	GROUP BY article_id;

CREATE TABLE VM_article_nbre_commentaire
ENGINE = InnoDB
SELECT Article.id as article_id,
	COALESCE(VM_preleminaire.nombre_commentaires, 0) AS nombre_commentaires
FROM Article
LEFT OUTER JOIN VM_preleminaire
	ON Article.id = VM_preleminaire.article_id
GROUP BY article_id;

DROP TABLE VM_preleminaire;

-- On ajoute maintenant des trigger sur la table
-- Commentaire pour tenir à jour VM_article_nbre_commentaire.
-- Pour cela il faut un trigger :
-- un lorsque l'on insert un nouveau commentaire.
-- un autre lorsque l'on supprime un commentaire.
DELIMITER |
CREATE TRIGGER after_insert_commentaire AFTER INSERT
ON Commentaire FOR EACH ROW
BEGIN 
	UPDATE VM_article_nbre_commentaire
	SET nombre_commentaires = nombre_commentaires + 1
	WHERE VM_article_nbre_commentaire.article_id = NEW.article_id;
END|

CREATE TRIGGER after_delete_commentaire AFTER DELETE
ON Commentaire FOR EACH ROW
BEGIN
	UPDATE VM_article_nbre_commentaire
	SET nombre_commentaires = nombre_commentaires - 1
	WHERE VM_article_nbre_commentaire.article_id = OLD.article_id;
END|

-- Même logique lorsque l'on insert un nouvel article, 
-- il y a zéro commentaire lié au nouvel article à son insertion.
CREATE TRIGGER after_insert_article AFTER INSERT
ON Article FOR EACH ROW
BEGIN
	INSERT INTO VM_article_nbre_commentaire(article_id, nombre_commentaires)
	VALUES(NEW.id, 0);
END|

CREATE TRIGGER after_delete_article AFTER DELETE
ON Article FOR EACH ROW
BEGIN
	DELETE FROM VM_article_nbre_commentaire
	WHERE article_id = OLD.id;
END|
DELIMITER ;


-- Amélioration 2 
-- Consignes :
-- Chaque article doit contenir un résumé (ou extrait), 
-- qui sera affiché sur la page d’accueil. 
-- Mais certains auteurs oublient parfois d’en écrire un. 
-- Il faut donc s’arranger pour créer automatiquement 
-- un résumé en prenant les 150 premiers caractères de 
-- l’article, si l’auteur n’en a pas écrit.


-- Trigger qui fait que si un article inséré a 
-- un resumé NULL, alors NEW.resume prend pour 
-- valeur les 150 premier caractère du contenu.  
DELIMITER |
CREATE TRIGGER before_insert_article BEFORE INSERT
ON Article FOR EACH ROW
BEGIN
	IF (NEW.resume IS NULL) THEN
		SET NEW.resume = RPAD(NEW.contenu, 150, '@');
	END IF;	
END| 
DELIMITER ;

-- En rab, j'ai décidé d'écrire aussi un trigger qui
-- fait que si un utilisateur veut changer le résumé en valeur NULL
-- alors une erreur est provoqué.
-- 
-- REMARQUE : On aurait aussi pu ajouter une contrainte NOT NULL 
-- sur la colone resumé. Mais cela me fait révisé l'exemple vu en cours. 
CREATE TABLE Erreur (
	id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	erreur VARCHAR(255) UNIQUE
)
ENGINE = InnoDB;

INSERT INTO Erreur(erreur)
VALUES('Le resume d''article ne peut pas être NULL.');

DELIMITER |
CREATE TRIGGER before_update_article BEFORE UPDATE
ON Article FOR EACH ROW
BEGIN
	IF (NEW.resume IS NULL) THEN
		INSERT INTO Erreur(erreur) 
		VAlUES('Le resume d''article ne peut pas être NULL.');
	END IF;
END|
DELIMITER ;


-- Amélioration 3
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
