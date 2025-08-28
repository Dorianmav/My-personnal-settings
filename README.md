# My-personnal-settings

# Personal Development Settings

Ce repository contient toutes mes configurations personnelles de développement pour avoir un environnement cohérent et optimisé sur toutes mes machines.

## 🚀 Installation rapide

```bash
# Cloner le repository
git clone https://github.com/votre-username/personal-dev-settings.git ~/personal-dev-settings
cd ~/personal-dev-settings

# Rendre le script executable et lancer l'installation
chmod +x scripts/setup.sh
./scripts/setup.sh
```

## 📁 Structure du repository

```
personal-dev-settings/
├── git/                    # Configuration Git
│   ├── .gitconfig         # Configuration Git globale
│   ├── .gitattributes     # Attributs par défaut
│   └── .gitignore_global  # Ignore patterns globaux
├── vscode/                # Configuration VS Code
│   ├── settings.json      # Paramètres VS Code
│   ├── keybindings.json   # Raccourcis clavier (optionnel)
│   └── extensions.txt     # Liste des extensions
├── prettier/              # Configuration Prettier
│   └── .prettierrc        # Règles de formatage
├── eslint/               # Configuration ESLint
│   └── .eslintrc.js      # Règles de linting
├── typescript/           # Configuration TypeScript
│   └── tsconfig.base.json # Config TypeScript réutilisable
├── scripts/              # Scripts utiles
│   ├── setup.sh          # Installation automatique
│   └── new-project.sh    # Création de nouveaux projets
└── README.md
```

## ⚙️ Configurations incluses

### Git
- **Alias utiles** : `git tree`, `git get`, `git ca`, `git wipe`, etc.
- **Optimisations Windows** : CRLF, cache filesystem, SSL
- **Workflows modernes** : rebase par défaut, branche main, auto-setup remote
- **Gitattributes** : Gestion automatique des fins de ligne par type de fichier
- **Gitignore global** : Patterns courants pour tous les projets

### VS Code
- **Formatage automatique** avec Prettier
- **Linting** avec ESLint
- **Thème et icônes** Material
- **Extensions essentielles** : TypeScript, Git, formatage, etc.
- **Optimisations** : smooth scrolling, bracket colorization, etc.

### Prettier
- **Style cohérent** : single quotes, trailing commas ES5, 100 chars
- **Overrides spécialisés** : HTML (120 chars), TypeScript, JSON
- **Compatibilité** : `endOfLine: "auto"` pour éviter les conflits CRLF/LF

### ESLint
- **Base solide** : ESLint recommended + TypeScript
- **Bonnes pratiques** : prefer-const, no-var, strict equality
- **TypeScript avancé** : optional chaining, nullish coalescing
- **Overrides** : configs spécifiques pour tests, React, fichiers config

### TypeScript
- **Configuration stricte** mais pragmatique
- **Path mapping** : aliases `@/*` pour imports courts
- **Optimisations** : skip lib check, isolated modules
- **Support moderne** : ES2020, decorators, resolution Node

## 🛠️ Scripts utiles

### Installation complète
```bash
./scripts/setup.sh
```
- Configure Git, VS Code, shell
- Installe les packages npm globaux
- Crée les dossiers de développement
- Configure les alias shell

### Nouveau projet
```bash
./scripts/new-project.sh mon-projet typescript
```

Templates disponibles :
- `typescript` : Projet TypeScript basique
- `node` : Projet Node.js moderne
- `react` : Projet React avec Vite
- `nestjs` : Projet NestJS

## 📋 Ce que fait l'installation

1. **Sauvegarde** vos configurations existantes
2. **Lie symboliquement** les configs Git
3. **Copie** les settings VS Code
4. **Installe** les extensions VS Code recommandées
5. **Configure** les packages npm globaux essentiels
6. **Crée** la structure de dossiers `~/Dev/`
7. **Ajoute** des alias shell utiles
8. **Génère** des templates de projet

## 🎯 Utilisation quotidienne

### Créer un nouveau projet
```bash
# Projet TypeScript simple
./scripts/new-project.sh mon-app typescript

# Projet React
./scripts/new-project.sh mon-site react

# Projet NestJS
./scripts/new-project.sh mon-api nestjs
```

### Synchroniser les changements
```bash
cd ~/personal-dev-settings
git add .
git commit -m "Update VS Code settings"
git push
```

### Appliquer sur une nouvelle machine
```bash
git clone [votre-repo] ~/personal-dev-settings
cd ~/personal-dev-settings
./scripts/setup.sh
```

## 🔧 Personnalisation

### Modifier la configuration Git
Éditez `git/.gitconfig` et relancez `./scripts/setup.sh`

### Ajouter des extensions VS Code
1. Ajoutez l'extension dans `vscode/extensions.txt`
2. Relancez `./scripts/setup.sh`

### Personnaliser Prettier/ESLint
1. Modifiez `prettier/.prettierrc` ou `eslint/.eslintrc.js`
2. Les nouveaux projets utiliseront automatiquement ces configs

## 📦 Packages npm globaux installés

- `prettier` - Formatage de code
- `eslint` - Linting JavaScript/TypeScript
- `typescript` - Compilateur TypeScript
- `ts-node` - Exécution TypeScript directe
- `nodemon` - Rechargement automatique
- `live-server` - Serveur de développement
- `rimraf` - Suppression cross-platform
- `concurrently` - Exécution de scripts parallèles

## 🚀 Alias Git utiles

- `git tree` - Historique graphique coloré
- `git get <branch>` - Checkout + pull en une commande
- `git ca` - Add all + amend + force push
- `git wipe <branch>` - Supprimer branche locale et distante
- `git tej <tag>` - Supprimer tag local et distant

## 🐛 Résolution de problèmes

### Problème CRLF/LF avec Prettier
Le fichier `.prettierrc` utilise `"endOfLine": "auto"` pour éviter les conflits.

### VS Code ne trouve pas les settings
Vérifiez le chemin de votre dossier VS Code :
- **macOS** : `~/Library/Application Support/Code/User/`
- **Linux** : `~/.config/Code/User/`
- **Windows** : `%APPDATA%/Code/User/`

### VS Code – Extensions recommandées
Ouvrez le projet dans VS Code : une popup proposera les extensions recommandées (cf. `.vscode/extensions.json`).  
Installation en ligne de commande (optionnelle) :  
```bash
cat .vscode/extensions.txt | grep -v "#" | xargs -n 1 code --install-extension
```

### Extensions VS Code non installées
Assurez-vous que la commande `code` est disponible dans votre PATH.

## 📝 Notes importantes

- **Sauvegarde automatique** : Le script sauvegarde vos configs existantes
- **Liens symboliques** : Les configs Git sont liées, pas copiées
- **Cross-platform** : Fonctionne sur Windows, macOS, Linux
- **Idempotent** : Peut être relancé sans problème

## 🤝 Contribution

1. Fork le repository
2. Créez votre branche de feature
3. Commitez vos changements
4. Poussez vers la branche
5. Ouvrez une Pull Request

## 📄 Licence

MIT - Libre d'utilisation et de modification.
