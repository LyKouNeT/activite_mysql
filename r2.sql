-- Sur la page d’accueil, on affiche le nombre 
-- de commentaires de chaque article. 
-- On veut éviter de calculer cela à chaque 
-- affichage de la page. Il faut donc stocker
-- ce nombre quelque part, et automatiser sa 
-- mise à jour afin que l’information soit toujours exacte.

-- On part su une Vue Matérialisé mise à jour sur UPDATE et DELETE par des triggers.

-- A chaque insert/delete d'un nouvel article, il faut mettre à jour la table VM_Article
-- A chaque insert/delete d'un commentaire, il faut mettre à jour VM_article

DELIMITER |
CREATE PROCEDURE creation_VM_article()
BEGIN
	CREATE TABLE VM_article
	ENGINE = InnoDB
	SELECT Article.id 
		Article.contenu, 
		Utilisateur.pseudo AS pseudo_de_l_auteur,
		Article.titre,
		Article.resume,
		DATE_FORMAT(Article.date_publication, '%d/%m/%Y') 
			AS Date_de_publication,
		COUNT(Commentaire.id) AS nombre_commentaires
	FROM Article
	LEFT OUTER JOIN Commentaire
		ON Article.id = Commentaire.article_id
	LEFT OUTER JOIN Utilisateur
		ON Article.auteur_id = Utilisateur.id
	GROUP BY Article.id 
		Article.contenu, 
		pseudo_de_l_auteur, 
		Article.titre, 
		Article.resume, 
		Date_de_publication
	ORDER BY Article.date_publication DESC;
END|
DELIMITER ;

CALL creation_VM_article();

DELIMITER |
CREATE TRIGGER after_insert_commentaire AFTER INSERT
ON Commentaire FOR EACH ROW
BEGIN 
	UPDATE VM_article
	SET nombre_commentaires += 1
	WHERE Article.id = NEW.article_id 

END|
DELIMITER ;

