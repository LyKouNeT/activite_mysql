DROP TABLE IF EXISTS Commentaire;
DROP TABLE IF EXISTS Article ;
DROP PROCEDURE IF EXISTS insert_article;

CREATE TABLE Article(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
)
ENGINE = InnoDB;

CREATE TABLE Commentaire(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	article_id INT UNSIGNED,

	CONSTRAINT fk_article_id
		FOREIGN KEY (article_id)
		REFERENCES Article(id)
)
ENGINE = InnoDB;

DELIMITER |
CREATE PROCEDURE insert_article ()
BEGIN 
	DECLARE v_iter INT DEFAULT 1;
	WHILE v_iter < 6 DO
		SET v_iter = v_iter + 1; 	
		INSERT INTO Article
		VALUES();
	END WHILE;
END |
DELIMITER ;

CALL insert_article;

-- SELECT * FROM Article;

INSERT INTO Commentaire(article_id)
VALUES(1), 
	(1), 
	(2),
	(5),
       	(5), 
	(5), 
	(2), 
	(2);

SELECT * FROM Article ORDER BY id;

SELECT * FROM Commentaire ORDER BY id;

SELECT Article.id AS article_id,
 	Commentaire.id AS commentaire_id
FROM Article
LEFT OUTER JOIN Commentaire
	ON Article.id = Commentaire.article_id
ORDER BY article_id;


-- C'est là qu'il y a un bug pour moi
-- puisque group by fait disparaitre article id = 4
SELECT Article.id AS article_id,
	COUNT(Commentaire.id) AS nombre_commentaire
FROM Article
LEFT OUTER JOIN Commentaire
	ON Article.id = Commentaire.article_id
GROUP BY article_id
ORDER BY article_id;
