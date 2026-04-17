from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from flask_socketio import SocketIO, emit

app = Flask(__name__)
app.config['SECRET_KEY'] = 'ma_cle_secrete_astronomie'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:root@localhost/astronomie_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

socketio = SocketIO(app)

db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# --- MODÈLES DE BASE DE DONNÉES ---

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False) # Sera hashé

class AppareilPhoto(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    categorie = db.Column(db.String(50), nullable=False)
    marque = db.Column(db.String(100), nullable=False)
    modele = db.Column(db.String(100), nullable=False)
    date_sortie = db.Column(db.String(50))
    score = db.Column(db.Integer)
    resume = db.Column(db.Text) # NOUVELLE COLONNE BONUS

class Telescope(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    categorie = db.Column(db.String(50), nullable=False)
    marque = db.Column(db.String(100), nullable=False)
    modele = db.Column(db.String(100), nullable=False)
    date_sortie = db.Column(db.String(50))
    score = db.Column(db.Integer)
    resume = db.Column(db.Text) # NOUVELLE COLONNE BONUS

class Photographie(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    titre = db.Column(db.String(150), nullable=False)
    description = db.Column(db.Text)
    url_image = db.Column(db.String(255), nullable=False)

class Actualite(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    message = db.Column(db.String(255), nullable=False)
    date_publication = db.Column(db.DateTime, default=db.func.current_timestamp())

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))



# --- ROUTES D'AUTHENTIFICATION ---

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        user = User.query.filter_by(username=username).first()
        if user:
            flash("Ce nom d'utilisateur existe déjà.")
            return redirect(url_for('register'))

        new_user = User(username=username, password=generate_password_hash(password, method='pbkdf2:sha256'))
        db.session.add(new_user)
        db.session.commit()
        
        flash('Inscription réussie ! Vous pouvez maintenant vous connecter.')
        return redirect(url_for('login'))
        
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        user = User.query.filter_by(username=username).first()

        if user and check_password_hash(user.password, password):
            login_user(user)
            return redirect(url_for('index'))
        else:
            flash('Identifiants incorrects. Veuillez réessayer.')
            
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

# --- ROUTE PRINCIPALE ---

@app.route('/')
@login_required
def index():
    return render_template('index.html')


# --- ROUTES POUR L'ASTRONOMIE ---

@app.route('/appareils')
@login_required
def appareils():
    liste_appareils = AppareilPhoto.query.all()
    return render_template('appareils.html', appareils=liste_appareils)

@app.route('/telescopes')
@login_required
def telescopes():
    liste_telescopes = Telescope.query.all()
    return render_template('telescopes.html', telescopes=liste_telescopes)

@app.route('/photographies')
@login_required
def photographies():
    liste_photos = Photographie.query.all()
    return render_template('photographies.html', photographies=liste_photos)

@app.route('/appareil/<int:id>')
@login_required
def appareil_detail(id):
    # Cherche l'appareil par son ID, renvoie une page 404 s'il n'existe pas
    appareil = AppareilPhoto.query.get_or_404(id)
    return render_template('appareil_detail.html', appareil=appareil)

@app.route('/telescope/<int:id>')
@login_required
def telescope_detail(id):
    telescope = Telescope.query.get_or_404(id)
    return render_template('telescope_detail.html', telescope=telescope)

@app.route('/actualites')
@login_required
def actualites():
    actus = Actualite.query.order_by(Actualite.date_publication.desc()).all()
    return render_template('actualites.html', actualites=actus)

@app.route('/post_news/<msg>')
@login_required
def post_news(msg):
    nouvelle_actu = Actualite(message=msg)
    db.session.add(nouvelle_actu)
    db.session.commit()
    
    socketio.emit('new_news', {'message': msg, 'date': 'À l\'instant'})
    return f"News postée : {msg}"

# --- ROUTE POUR AJOUTER DES DONNÉES DE TEST ---

@app.route('/init_data')
@login_required
def init_data():
    if AppareilPhoto.query.count() == 0:
        db.session.add_all([
            AppareilPhoto(categorie='Amateur', marque='Canon', modele='EOS 2000D', date_sortie='2018', score=4, resume='Appareil idéal pour débuter en astrophotographie avec un budget maîtrisé.'),
            AppareilPhoto(categorie='Amateur sérieux', marque='Nikon', modele='D7500', date_sortie='2017', score=5, resume='Excellente montée en ISO, parfait pour capturer la voie lactée.'),
            AppareilPhoto(categorie='Professionnel', marque='Sony', modele='Alpha 7 IV', date_sortie='2021', score=5, resume='Capteur plein format surpuissant pour les ciels profonds les plus sombres.')
        ])
    
    if Telescope.query.count() == 0:
        db.session.add_all([
            Telescope(categorie='Téléscopes pour enfants', marque='Celestron', modele='FirstScope', date_sortie='2019', score=3, resume='Compact et facile à utiliser pour observer la lune depuis sa chambre.'),
            Telescope(categorie='Automatisés', marque='Sky-Watcher', modele='Maksutov', date_sortie='2020', score=4, resume='Motorisé avec suivi automatique des planètes, idéal pour ne jamais perdre sa cible.'),
            Telescope(categorie='Téléscopes complets', marque='Orion', modele='SkyQuest XT8', date_sortie='2015', score=5, resume='Le classique Dobson 200mm, un puits de lumière incroyable pour observer les nébuleuses.')
        ])

    if Photographie.query.count() == 0:
        db.session.add_all([
            Photographie(titre="Nébuleuse d'Orion", description="Une des nébuleuses les plus brillantes, visible à l'œil nu.", url_image="https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=800&auto=format&fit=crop"),
            Photographie(titre="Galaxie d'Andromède", description="La galaxie spirale la plus proche de notre Voie lactée.", url_image="https://images.unsplash.com/photo-1543722530-d2c3201371e7?q=80&w=800&auto=format&fit=crop"),
            Photographie(titre="Surface lunaire", description="Détail des cratères de notre satellite naturel.", url_image="https://images.unsplash.com/photo-1522030299830-16b8d3d049fe?q=80&w=800&auto=format&fit=crop")
        ])
        
    db.session.commit()
    flash('Données de test ajoutées avec succès dans la base de données !')
    return redirect(url_for('index'))


if __name__ == '__main__':
    socketio.run(app, debug=True)