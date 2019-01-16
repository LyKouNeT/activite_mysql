-- Amélioration 2 
-- Consigne :
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


-- La première idée fut de faire une procedure
-- mais on va plutôt agir lors de l'insertion 
-- d'un nouvel article. 
-- DELIMITER |
-- CREATE PROCEDURE get_article_resume(IN p_article_id INT)
-- BEGIN
-- 	SELECT COALESCE(resume, RPAD(contenu, 150, ' '))
-- 	FROM Article
-- 	WHERE id = p_article_id;
-- END |
-- DELIMITER ;
