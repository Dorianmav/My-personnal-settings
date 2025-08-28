#!/bin/bash

# Personal Development Settings Setup Script
# Usage: ./scripts/setup.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

log_info "Starting Personal Development Settings Setup..."
log_info "Root directory: $ROOT_DIR"

# Backup existing configurations
backup_config() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local backup_file="${file}.backup.$(date +%Y%m%d-%H%M%S)"
        cp "$file" "$backup_file"
        log_warning "Backed up existing $file to $backup_file"
    fi
}

# Git configuration
log_info "Setting up Git configuration..."

# Backup existing git config
backup_config "$HOME/.gitconfig"
backup_config "$HOME/.gitattributes"
backup_config "$HOME/.gitignore_global"

# Create symlinks for git configs
if [[ -f "$ROOT_DIR/git/.gitconfig" ]]; then
    ln -sf "$ROOT_DIR/git/.gitconfig" "$HOME/.gitconfig"
    log_success "Linked .gitconfig"
else
    log_warning "git/.gitconfig not found, skipping"
fi

if [[ -f "$ROOT_DIR/git/.gitattributes" ]]; then
    ln -sf "$ROOT_DIR/git/.gitattributes" "$HOME/.gitattributes"
    log_success "Linked .gitattributes"
fi

if [[ -f "$ROOT_DIR/git/.gitignore_global" ]]; then
    ln -sf "$ROOT_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
    log_success "Linked .gitignore_global"
fi

# VS Code configuration
log_info "Setting up VS Code configuration..."

# Detect VS Code settings directory
VSCODE_SETTINGS_DIR=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    VSCODE_SETTINGS_DIR="$HOME/.config/Code/User"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    # Windows (Git Bash/Cygwin)
    VSCODE_SETTINGS_DIR="$APPDATA/Code/User"
fi

if [[ -n "$VSCODE_SETTINGS_DIR" ]] && [[ -d "$VSCODE_SETTINGS_DIR" ]]; then
    # Backup existing VS Code settings
    backup_config "$VSCODE_SETTINGS_DIR/settings.json"
    backup_config "$VSCODE_SETTINGS_DIR/keybindings.json"

    # Copy VS Code settings
    if [[ -f "$ROOT_DIR/vscode/settings.json" ]]; then
        cp "$ROOT_DIR/vscode/settings.json" "$VSCODE_SETTINGS_DIR/settings.json"
        log_success "Copied VS Code settings.json"
    fi

    if [[ -f "$ROOT_DIR/vscode/keybindings.json" ]]; then
        cp "$ROOT_DIR/vscode/keybindings.json" "$VSCODE_SETTINGS_DIR/keybindings.json"
        log_success "Copied VS Code keybindings.json"
    fi

    # Install VS Code extensions if extensions.txt exists
    if [[ -f "$ROOT_DIR/vscode/extensions.txt" ]] && command -v code &> /dev/null; then
        log_info "Installing VS Code extensions..."
        while IFS= read -r extension || [[ -n "$extension" ]]; do
            # Skip comments and empty lines
            if [[ ! "$extension" =~ ^#.* ]] && [[ -n "$extension" ]]; then
                log_info "Installing: $extension"
                code --install-extension "$extension" || log_warning "Failed to install $extension"
            fi
        done < "$ROOT_DIR/vscode/extensions.txt"
        log_success "VS Code extensions installation completed"
    else
        if [[ ! -f "$ROOT_DIR/vscode/extensions.txt" ]]; then
            log_warning "extensions.txt not found, skipping extensions installation"
        else
            log_warning "VS Code CLI not found, skipping extensions installation"
        fi
    fi
else
    log_warning "VS Code settings directory not found, skipping VS Code configuration"
fi

# Node.js and npm global packages
log_info "Setting up Node.js global packages..."

# Check if npm is available
if command -v npm &> /dev/null; then
    # Essential global packages
    GLOBAL_PACKAGES=(
        "prettier"
        "eslint"
        "@typescript-eslint/parser"
        "@typescript-eslint/eslint-plugin"
        "typescript"
        "ts-node"
        "nodemon"
        "live-server"
        "http-server"
        "rimraf"
        "concurrently"
    )

    for package in "${GLOBAL_PACKAGES[@]}"; do
        if ! npm list -g "$package" &> /dev/null; then
            log_info "Installing global package: $package"
            npm install -g "$package" || log_warning "Failed to install $package"
        else
            log_info "Package $package already installed globally"
        fi
    done
    log_success "Global npm packages setup completed"
else
    log_warning "npm not found, skipping global packages installation"
fi

# Create useful directories
log_info "Creating useful directories..."

USEFUL_DIRS=(
    "$HOME/Dev"
    "$HOME/Dev/projects"
    "$HOME/Dev/sandbox"
    "$HOME/Dev/templates"
)

for dir in "${USEFUL_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_success "Created directory: $dir"
    else
        log_info "Directory already exists: $dir"
    fi
done

# Setup shell configuration (if applicable)
log_info "Setting up shell configuration..."

# Detect shell
CURRENT_SHELL=$(basename "$SHELL")

case "$CURRENT_SHELL" in
    "bash")
        SHELL_CONFIG="$HOME/.bashrc"
        ;;
    "zsh")
        SHELL_CONFIG="$HOME/.zshrc"
        ;;
    *)
        log_warning "Unknown shell: $CURRENT_SHELL, skipping shell configuration"
        SHELL_CONFIG=""
        ;;
esac

if [[ -n "$SHELL_CONFIG" ]]; then
    # Add useful aliases if not already present
    ALIASES_TO_ADD='
# Personal Dev Aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gbr="git branch"
alias glog="git log --oneline --graph --decorate"
alias npmls="npm list --depth=0"
alias npmlsg="npm list -g --depth=0"
alias serve="live-server --port=3000"
alias weather="curl wttr.in"
'

    if ! grep -q "Personal Dev Aliases" "$SHELL_CONFIG" 2>/dev/null; then
        echo "$ALIASES_TO_ADD" >> "$SHELL_CONFIG"
        log_success "Added personal aliases to $SHELL_CONFIG"
    else
        log_info "Personal aliases already present in $SHELL_CONFIG"
    fi

    # Add PATH modifications if needed
    if [[ "$CURRENT_SHELL" == "bash" ]] && [[ ! "$PATH" == *"$HOME/.local/bin"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_CONFIG"
        log_success "Added ~/.local/bin to PATH in $SHELL_CONFIG"
    fi
fi

# Create project templates
log_info "Setting up project templates..."

TEMPLATES_DIR="$HOME/Dev/templates"

# Basic TypeScript project template
TS_TEMPLATE_DIR="$TEMPLATES_DIR/typescript-basic"
if [[ ! -d "$TS_TEMPLATE_DIR" ]]; then
    mkdir -p "$TS_TEMPLATE_DIR"
    
    # Copy base configs to template
    [[ -f "$ROOT_DIR/prettier/.prettierrc" ]] && cp "$ROOT_DIR/prettier/.prettierrc" "$TS_TEMPLATE_DIR/"
    [[ -f "$ROOT_DIR/eslint/.eslintrc.js" ]] && cp "$ROOT_DIR/eslint/.eslintrc.js" "$TS_TEMPLATE_DIR/"
    [[ -f "$ROOT_DIR/typescript/tsconfig.base.json" ]] && cp "$ROOT_DIR/typescript/tsconfig.base.json" "$TS_TEMPLATE_DIR/tsconfig.json"
    
    # Create basic package.json template
    cat > "$TS_TEMPLATE_DIR/package.json" << 'EOF'
{
  "name": "typescript-project",
  "version": "1.0.0",
  "description": "",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "dev": "ts-node src/index.ts",
    "start": "node dist/index.js",
    "lint": "eslint src/**/*.ts",
    "lint:fix": "eslint src/**/*.ts --fix",
    "format": "prettier --write src/**/*.ts",
    "clean": "rimraf dist"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "rimraf": "^5.0.0",
    "ts-node": "^10.0.0",
    "typescript": "^5.0.0"
  }
}
EOF

    # Create basic src structure
    mkdir -p "$TS_TEMPLATE_DIR/src"
    echo 'console.log("Hello, TypeScript!");' > "$TS_TEMPLATE_DIR/src/index.ts"
    
    log_success "Created TypeScript project template"
fi

# Verification
log_info "Verifying setup..."

# Check Git configuration
if git config --global user.name &> /dev/null; then
    log_success "Git user name configured: $(git config --global user.name)"
else
    log_warning "Git user name not configured. Run: git config --global user.name 'Your Name'"
fi

if git config --global user.email &> /dev/null; then
    log_success "Git user email configured: $(git config --global user.email)"
else
    log_warning "Git user email not configured. Run: git config --global user.email 'your.email@example.com'"
fi

# Check if essential tools are installed
ESSENTIAL_TOOLS=("git" "node" "npm" "code")
for tool in "${ESSENTIAL_TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        log_success "$tool is installed: $(command -v "$tool")"
    else
        log_warning "$tool is not installed"
    fi
done

# Final message
echo ""
log_success "🎉 Personal Development Settings setup completed!"
echo ""
log_info "Next steps:"
echo "  1. Update Git user name and email if not already configured"
echo "  2. Restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc)"
echo "  3. Restart VS Code to apply new settings"
echo "  4. Create a new project using: cp -r ~/Dev/templates/typescript-basic ~/Dev/projects/my-project"
echo ""
log_info "Happy coding! 🚀"