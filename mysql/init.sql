-- web/init.sql

CREATE DATABASE IF NOT EXISTS flask_app;

USE flask_app;

CREATE TABLE IF NOT EXISTS planning(
   id_planning INTEGER NOT NULL AUTO_INCREMENT,
   diplome VARCHAR(50),
   annee VARCHAR(50),
   classe VARCHAR(50),
   PRIMARY KEY(id_planning)
);

CREATE TABLE IF NOT EXISTS ecole(
   id_ecole INTEGER NOT NULL AUTO_INCREMENT,
   raison_sociale VARCHAR(200),
   adresse VARCHAR(200),
   PRIMARY KEY(id_ecole)
);

CREATE TABLE IF NOT EXISTS role(
   id_role INT,
   nom VARCHAR(50),
   PRIMARY KEY(id_role)
);

CREATE TABLE IF NOT EXISTS entreprise(
   id_entreprise INTEGER NOT NULL AUTO_INCREMENT,
   raison_sociale VARCHAR(200),
   adresse VARCHAR(200),
   id_ecole INT,
   PRIMARY KEY(id_entreprise),
   FOREIGN KEY(id_ecole) REFERENCES ecole(id_ecole)
);

CREATE TABLE IF NOT EXISTS utilisateur(
   id_user INTEGER NOT NULL AUTO_INCREMENT,
   nom VARCHAR(50),
   prenom VARCHAR(50),
   mail VARCHAR(50),
   date_naissance DATE,
   statut BOOLEAN,
   password VARCHAR(256),
   id_user_1 INT,
   id_user_2 INT,
   id_ecole INT,
   id_ecole_1 INT,
   id_ecole_2 INT,
   id_entreprise INT,
   id_entreprise_1 INT,
   id_role INT,
   id_user_3 INT,
   id_planning INT,
   PRIMARY KEY(id_user),
   FOREIGN KEY(id_user_1) REFERENCES utilisateur(id_user),
   FOREIGN KEY(id_user_2) REFERENCES utilisateur(id_user),
   FOREIGN KEY(id_ecole) REFERENCES ecole(id_ecole),
   FOREIGN KEY(id_ecole_1) REFERENCES ecole(id_ecole),
   FOREIGN KEY(id_ecole_2) REFERENCES ecole(id_ecole),
   FOREIGN KEY(id_entreprise) REFERENCES entreprise(id_entreprise),
   FOREIGN KEY(id_entreprise_1) REFERENCES entreprise(id_entreprise),
   FOREIGN KEY(id_role) REFERENCES role(id_role),
   FOREIGN KEY(id_user_3) REFERENCES utilisateur(id_user),
   FOREIGN KEY(id_planning) REFERENCES planning(id_planning)
);

CREATE TABLE IF NOT EXISTS mission(
   id_mission INTEGER NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   description VARCHAR(50),
   datedebut DATE,
   datefin DATE,
   id_user INT,
   PRIMARY KEY(id_mission),
   FOREIGN KEY(id_user) REFERENCES utilisateur(id_user)
);

CREATE TABLE IF NOT EXISTS evaluation(
   id_evaluation INTEGER NOT NULL AUTO_INCREMENT,
   dateevaluation DATE,
   id_user INT,
   PRIMARY KEY(id_evaluation),
   FOREIGN KEY(id_user) REFERENCES utilisateur(id_user)
);

CREATE TABLE IF NOT EXISTS document_(
   id_doc INTEGER NOT NULL AUTO_INCREMENT,
   nom VARCHAR(50),
   md5 VARCHAR(50),
   type VARCHAR(50),
   datecreation DATE,
   datesuppression DATE,
   id_user INT,
   id_user_1 INT,
   PRIMARY KEY(id_doc),
   FOREIGN KEY(id_user) REFERENCES utilisateur(id_user),
   FOREIGN KEY(id_user_1) REFERENCES utilisateur(id_user)
);

CREATE TABLE IF NOT EXISTS contrat(
   id_contrat INTEGER NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   datecreation VARCHAR(50),
   datesuppression VARCHAR(50),
   id_user INT,
   PRIMARY KEY(id_contrat),
   FOREIGN KEY(id_user) REFERENCES utilisateur(id_user)
);

CREATE TABLE IF NOT EXISTS conflit(
   id_conflit INTEGER NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   datecreation DATE,
   datesuppression DATE,
   id_user INT,
   PRIMARY KEY(id_conflit),
   FOREIGN KEY(id_user) REFERENCES utilisateur(id_user)
);

CREATE TABLE IF NOT EXISTS programme(
   id_programme INTEGER NOT NULL AUTO_INCREMENT,
   diplome VARCHAR(50),
   annee VARCHAR(50),
   id_user INT,
   PRIMARY KEY(id_programme),
   FOREIGN KEY(id_user) REFERENCES utilisateur(id_user)
);


CREATE USER root@root IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON flask_app.* TO root@root;
FLUSH PRIVILEGES;