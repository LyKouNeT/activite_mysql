-- Consignes :
-- Sur la page d’accueil, on affiche le nombre 
-- de commentaires de chaque article. 
-- On veut éviter de calculer cela à chaque 
-- affichage de la page. Il faut donc stocker
-- ce nombre quelque part, et automatiser sa 
-- mise à jour afin que l’information soit toujours exacte.

-- On stocke le nombre de commentaire par 
-- article dans la vue matérialisée suivante :
CREATE TABLE VM_article_nbre_commentaire
	ENGINE = InnoDB
	SELECT Article.id as article_id,
		COUNT(Commentaire.id) AS nombre_commentaires
	FROM Article
	LEFT OUTER JOIN Commentaire
		ON Article.id = Commentaire.article_id
	GROUP BY article_id;

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
