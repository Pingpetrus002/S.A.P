# Import des modules nécessaires
from flask import Blueprint, request, jsonify, render_template
from flask_mail import Message, Mail
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity, set_access_cookies, unset_jwt_cookies
from werkzeug.security import generate_password_hash, check_password_hash
from .models import Utilisateur, db 

import re 
import random  
import string 

# Création d'un blueprint pour les routes d'authentification
auth = Blueprint('auth', __name__)
mail = Mail()  # Initialisation de l'extension Flask-Mail pour l'envoi de mails

# Fonction pour générer un mot de passe aléatoire
def generate_random_password(length=6):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for i in range(length))

# Fonction pour envoyer un email de bienvenue à un nouvel utilisateur
def send_welcome_email(username, password):
    msg = Message('Bienvenue sur MySAP !', recipients=[username])
    msg.html = render_template('welcome_email.html', username=username, password=password)
    mail.send(msg)

# Fonction pour vérifier le rôle d'un utilisateur
def check_role(user, role):
    return user.id_role == role

# Route pour l'inscription d'un nouvel utilisateur
@auth.route('/register', methods=['POST'])
@jwt_required()
def register():
    current_identity = get_jwt_identity()  # Récupération de l'identité actuelle depuis le token JWT

    # Récupération des données du formulaire
    data = request.get_json()
    username = data.get('username')
    firstname = data.get('firstname')
    lastname = data.get('lastname')
    date_naissance = data.get('date_naissance')
    role = data.get('role')
    
    password = generate_random_password()  # Génération d'un mot de passe aléatoire

    # Vérification du rôle de l'utilisateur actuel 
    if not check_role(Utilisateur.query.get(current_identity), 1) and not check_role(Utilisateur.query.get(current_identity), 2):
        return jsonify({'message': 'Unauthorized'}), 403

    # Validation de l'adresse email avec une expression régulière
    if not re.match(r"[^@]+@[^@]+\.[^@]+", username):
        return jsonify({'message': 'Invalid email address'}), 400

    # Vérification de l'unicité de l'adresse email
    if Utilisateur.query.filter_by(mail=username).first():
        return jsonify({'message': 'User already exists'}), 409

    # Hachage du mot de passe avant de le stocker dans la base de données
    hashed_password = generate_password_hash(password)
    new_user = Utilisateur(mail=username, password=hashed_password, nom=lastname, prenom=firstname, date_naissance=date_naissance, id_role=role)
    db.session.add(new_user)
    db.session.commit()

    # Envoi d'un email de bienvenue à l'utilisateur avec son mot de passe
    send_welcome_email(username, password)

    return jsonify({'message': 'User created'}), 201

# Route pour la connexion d'un utilisateur
@auth.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    # Récupération de l'utilisateur depuis la base de données
    user = Utilisateur.query.filter_by(mail=username).first()
    # Vérification de l'existence de l'utilisateur et de la correspondance du mot de passe
    if not user or not check_password_hash(user.password, password):
        return jsonify({'message': 'Invalid credentials'}), 401

    # Création d'un token JWT pour l'utilisateur authentifié
    access_token = create_access_token(identity=user.id_user)
    response = jsonify({'message': 'Login successful'})
    # Configuration du cookie d'accès avec le token JWT
    set_access_cookies(response, access_token)
    
    return response, 200

# Route pour la déconnexion d'un utilisateur
@auth.route('/logout', methods=['GET'])
@jwt_required()
def logout():
    response = jsonify({'message': 'Logout successful'})
    # Suppression du cookie JWT de l'utilisateur
    unset_jwt_cookies(response)
    return response, 200

# Route protégée accessible uniquement aux utilisateurs authentifiés
@auth.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    current_user = get_jwt_identity()
    return jsonify({'message': f'Welcome user {current_user}'}), 200

# Route pour récupérer le profil de l'utilisateur actuellement authentifié
@auth.route('/get_profil', methods=['GET'])
@jwt_required()
def get_profil():
    current_user = get_jwt_identity()
    user = Utilisateur.query.get(current_user)
    return jsonify({'user': {
        'id_user': user.id_user,
        'nom': user.nom,
        'prenom': user.prenom,
        'mail': user.mail,
        'date_naissance': user.date_naissance,
        'statut': user.statut,
        'id_user_1': user.id_user_1,
        'id_user_2': user.id_user_2,
        'id_ecole': user.id_ecole,
        'id_ecole_1': user.id_ecole_1,
        'id_ecole_2': user.id_ecole_2,
        'id_entreprise': user.id_entreprise,
        'id_entreprise_1': user.id_entreprise_1,
        'id_role': user.id_role,
        'id_user_3': user.id_user_3,
        'id_planning': user.id_planning
    }}), 200

