#!/usr/bin/env bash

set -euo pipefail

# ==============================================================================
# Script : extract-todos.sh
#
# Objectif :
#   Extraire toutes les lignes contenant "TODO:" dans les fichiers suivis par Git
#   pour certains types de fichiers, puis générer un fichier Markdown.
#
# Exemples d'usage :
#   ./extract-todos.sh
#   ./extract-todos.sh --types ts,html
#   ./extract-todos.sh --types ts html
#   ./extract-todos.sh --types .ts,.html -o TODOS.md
#   ./extract-todos.sh TODOS.md
#   ./extract-todos.sh --help
#
# Avec Yarn :
#   yarn todos
#   yarn todos --types ts,html
#   yarn todos -- --types ts html -o TODOS.md
# ==============================================================================

# ------------------------------------------------------------------------------
# Valeurs par défaut.
# ------------------------------------------------------------------------------

OUTPUT_FILE="TODO.md"
TODO_PATTERN="TODO:"
TYPES_RAW=()
POSITIONAL_OUTPUT_SET=0

# ------------------------------------------------------------------------------
# Affiche l'aide.
# ------------------------------------------------------------------------------

print_help() {
  cat <<'EOF'
Usage :
  extract-todos.sh [options] [fichier_sortie.md]

Description :
  Parcourt les fichiers suivis par Git et extrait les lignes contenant "TODO:".
  Génère ensuite un rapport Markdown.

Options :
  -t, --types <types...>
      Types de fichiers à analyser.

      Formats acceptés :
        --types ts,html
        --types ts html
        --types .ts,.html

      Par défaut :
        ts,html

  -o, --output <fichier.md>
      Fichier Markdown de sortie.

      Par défaut :
        TODO.md

  -h, --help
      Affiche cette aide.

Arguments :
  fichier_sortie.md
      Alternative courte à --output.
      Exemple :
        extract-todos.sh TODOS.md

Notes :
  Si tu utilises --types avec des types séparés par des espaces,
  utilise plutôt -o ou --output pour préciser le fichier de sortie,
  afin d'éviter toute ambiguïté.

Exemples :
  extract-todos.sh
  extract-todos.sh --types ts,html
  extract-todos.sh --types ts html
  extract-todos.sh --types ts html -o TODOS.md
  extract-todos.sh TODOS.md
EOF
}

# ------------------------------------------------------------------------------
# Affiche une erreur puis quitte.
# ------------------------------------------------------------------------------

die() {
  echo "Erreur : $*" >&2
  echo >&2
  echo "Utilise --help pour afficher les options disponibles." >&2
  exit 1
}

# ------------------------------------------------------------------------------
# Parsing des arguments.
#
# Règles :
#   --types ts,html      => OK
#   --types ts html      => OK
#   --types=.ts,.html    => OK
#   -o TODO.md           => OK
#   --output TODO.md     => OK
#   TODO.md              => OK, argument positionnel conservé
# ------------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      print_help
      exit 0
      ;;

    -t|--types=*)
      TYPES_RAW+=("${1#*=}")
      shift
      ;;

    -t|--types)
      shift

      if [[ $# -eq 0 || "$1" == -* ]]; then
        die "l'option --types attend au moins un type de fichier."
      fi

      # On accepte plusieurs arguments après --types jusqu'à la prochaine option.
      # Exemple :
      #   --types ts html -o TODOS.md
      while [[ $# -gt 0 && "$1" != -* ]]; do
        TYPES_RAW+=("$1")
        shift
      done
      ;;

    -o|--output)
      shift

      if [[ $# -eq 0 || "$1" == -* ]]; then
        die "l'option --output attend un nom de fichier."
      fi

      OUTPUT_FILE="$1"
      shift
      ;;

    --output=*)
      OUTPUT_FILE="${1#*=}"
      shift
      ;;

    --)
      shift

      if [[ $# -gt 0 ]]; then
        if [[ "$POSITIONAL_OUTPUT_SET" -eq 1 ]]; then
          die "plusieurs fichiers de sortie ont été fournis."
        fi

        OUTPUT_FILE="$1"
        POSITIONAL_OUTPUT_SET=1
        shift
      fi

      if [[ $# -gt 0 ]]; then
        die "arguments inattendus après '--' : $*"
      fi
      ;;

    -*)
      die "option inconnue : $1"
      ;;

    *)
      # Argument positionnel : fichier de sortie.
      # Exemple :
      #   ./extract-todos.sh TODOS.md
      if [[ "$POSITIONAL_OUTPUT_SET" -eq 1 ]]; then
        die "plusieurs fichiers de sortie ont été fournis : '$OUTPUT_FILE' et '$1'."
      fi

      OUTPUT_FILE="$1"
      POSITIONAL_OUTPUT_SET=1
      shift
      ;;
  esac
done

# ------------------------------------------------------------------------------
# Types par défaut.
# ------------------------------------------------------------------------------

if [[ "${#TYPES_RAW[@]}" -eq 0 ]]; then
  TYPES_RAW=("ts" "html")
fi

# ------------------------------------------------------------------------------
# Normalisation des types.
#
# Accepte :
#   ts
#   html
#   .ts
#   .html
#   ts,html
#   .ts,.html
#
# Produit :
#   ts
#   html
# ------------------------------------------------------------------------------

TYPES=()

for raw_type_group in "${TYPES_RAW[@]}"; do
  # Découpe les groupes séparés par des virgules.
  # Exemple : "ts,html" => "ts" "html"
  IFS=',' read -r -a split_types <<< "$raw_type_group"

  for type in "${split_types[@]}"; do
    # Supprime les espaces éventuels.
    type="${type//[[:space:]]/}"

    # Supprime un point initial éventuel.
    type="${type#.}"

    if [[ -z "$type" ]]; then
      continue
    fi

    # Validation simple pour éviter les pathspecs trop ambigus.
    # On accepte les extensions courantes : ts, html, spec.ts serait refusé ici.
    # Pour spec.ts, il faut utiliser ts, car on filtre par extension.
    if [[ ! "$type" =~ ^[A-Za-z0-9_-]+$ ]]; then
      die "type de fichier invalide : '$type'. Utilise par exemple : ts, html, scss."
    fi

    TYPES+=("$type")
  done
done

if [[ "${#TYPES[@]}" -eq 0 ]]; then
  die "aucun type de fichier valide fourni."
fi

# ------------------------------------------------------------------------------
# Déduplication des types.
# ------------------------------------------------------------------------------

UNIQUE_TYPES=()

for type in "${TYPES[@]}"; do
  already_present=0

  for existing_type in "${UNIQUE_TYPES[@]}"; do
    if [[ "$existing_type" == "$type" ]]; then
      already_present=1
      break
    fi
  done

  if [[ "$already_present" -eq 0 ]]; then
    UNIQUE_TYPES+=("$type")
  fi
done

TYPES=("${UNIQUE_TYPES[@]}")


# ------------------------------------------------------------------------------
# Construction des pathspecs Git.
#
# Exemple :
#   TYPES=(ts html)
#   PATHSPECS=("*.ts" "*.html")
# ------------------------------------------------------------------------------

PATHSPECS=()

for type in "${TYPES[@]}"; do
  PATHSPECS+=("*.$type")
done

# ------------------------------------------------------------------------------
# Petite fonction utilitaire pour afficher les types dans le Markdown.
# ------------------------------------------------------------------------------

join_types_for_markdown() {
  local result=""
  local type

  for type in "${TYPES[@]}"; do
    if [[ -z "$result" ]]; then
      result="\`.$type\`"
    else
      result="$result, \`.$type\`"
    fi
  done

  printf '%s' "$result"
}

# ------------------------------------------------------------------------------
# Vérifications d'environnement.
# ------------------------------------------------------------------------------

for command_name in git grep mktemp wc tr; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Erreur : la commande '$command_name' est introuvable dans le PATH." >&2
    exit 127
  fi
done

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Erreur : ce script doit être lancé depuis un dépôt Git." >&2
  exit 1
fi

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
cd "$PROJECT_ROOT"

TEMP_FILE="$(mktemp)"

cleanup() {
  rm -f "$TEMP_FILE"
}

trap cleanup EXIT

# Initialise le fichier temporaire.
: > "$TEMP_FILE"

# Fichier Markdown de sortie.
# Si un argument est fourni, on l'utilise comme nom de fichier.
# Sinon, on génère TODOS.md par défaut.
OUTPUT_FILE="${1:-TODOS.md}"

# Vérifie que le script est exécuté dans un dépôt Git.
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Erreur : ce script doit être lancé depuis un dépôt Git."
  exit 1
fi

# Récupère la racine du dépôt Git.
PROJECT_ROOT="$(git rev-parse --show-toplevel)"

# Se place à la racine du projet pour avoir des chemins propres et relatifs.
cd "$PROJECT_ROOT"

# Initialise le fichier Markdown.
cat > "$OUTPUT_FILE" <<EOF
# Liste des TODO

Fichier généré automatiquement.

## Résumé

EOF

# Compteur global de TODO.
TODO_COUNT=0

# Fichier temporaire pour stocker les résultats avant génération finale.
TEMP_FILE="$(mktemp)"
: > "$TEMP_FILE"

# Nettoyage automatique du fichier temporaire à la fin du script.
trap 'rm -f "$TEMP_FILE"' EXIT

# ------------------------------------------------------------------------------
# Recherche des TODO:
#
# - git ls-files permet de parcourir uniquement les fichiers suivis par Git.
# - On limite aux extensions .ts et .html.
# - On exclut implicitement node_modules, dist, etc. s'ils ne sont pas suivis.
# - grep cherche "TODO:" avec numéro de ligne.
#
# Format grep :
#   chemin/fichier:numero_ligne:contenu
# ------------------------------------------------------------------------------

git ls-files '*.ts' '*.html' | while IFS= read -r file; do
  # Ignore certains fichiers générés ou peu pertinents, au cas où ils seraient suivis.
  case "$file" in
    node_modules/*|dist/*|coverage/*|.angular/*|.git/*)
      continue
      ;;
  esac
    
    # Sécurité : le fichier est suivi par Git mais absent du workspace.
    if [[ ! -f "$file" ]]; then
        echo "Avertissement : fichier introuvable, ignoré : $file" >&2
        continue
    fi

    # Sécurité : le fichier existe mais n'est pas lisible.
    if [[ ! -r "$file" ]]; then
        echo "Avertissement : fichier non lisible, ignoré : $file" >&2
        continue
    fi

# Recherche simple : tous les TODO: dans les fichiers .ts et .html.
  # grep retourne :
  #   0 si au moins une ligne est trouvée
  #   1 si aucune ligne n'est trouvée
  #   >1 en cas d'erreur réelle
  if matches="$(grep -n "TODO:" "$file" 2>/dev/null)"; then
    while IFS= read -r match; do
      line_number="${match%%:*}"
      todo_content="${match#*:}"

      # Important :
      # on écrit explicitement dans TEMP_FILE.
      # Sinon grep affiche seulement dans la console.
      printf '%s\t%s\t%s\n' "$file" "$line_number" "$todo_content" >> "$TEMP_FILE"
    done <<< "$matches"
  else
    grep_status=$?


    # Code 1 = aucun TODO trouvé dans ce fichier, ce n'est pas une erreur.
    if [[ "$grep_status" -ne 1 ]]; then
      echo "Erreur : grep a échoué sur le fichier '$file' avec le code $grep_status." >&2
      exit "$grep_status"
    fi
  fi
done


# Compte le nombre de TODO trouvés.
if [[ -s "$TEMP_FILE" ]]; then
  TODO_COUNT="$(wc -l < "$TEMP_FILE" | tr -d ' ')"
else
  TODO_COUNT=0
fi

# Ajoute le résumé dans le fichier Markdown.4:
{
  echo "- Nombre total de TODO trouvés : **$TODO_COUNT**"
  echo "- Extensions analysées : \`.ts\`, \`.html\`"
  echo "- Racine du projet : \`$PROJECT_ROOT\`"
  echo
  echo "## Détail"
  echo
} >> "$OUTPUT_FILE"

# Si aucun TODO n'est trouvé, on l'indique clairement.
if [[ "$TODO_COUNT" -eq 0 ]]; then
  echo "Aucun \`TODO:\` trouvé dans les fichiers TypeScript ou HTML." >> "$OUTPUT_FILE"
  echo "Aucun TODO trouvé. Fichier généré : $OUTPUT_FILE"
  exit 0
fi

# ------------------------------------------------------------------------------
# Génération du détail Markdown.
#
# On regroupe les TODO par fichier.
# Chaque entrée contient :
# - le chemin du fichier
# - le numéro de ligne
# - le contenu de la ligne
# ------------------------------------------------------------------------------

current_file=""

while IFS=$'\t' read -r file line_number todo_content; do
  if [[ "$file" != "$current_file" ]]; then
    current_file="$file"
    {
      echo
      echo "### \`$current_file\`"
      echo
    } >> "$OUTPUT_FILE"
  fi

  # Échappe les backticks pour éviter de casser le Markdown inline.
  safe_content="${todo_content//\`/\\\`}"

  # On ajoute le lien direct au fichier sur le texte remonté.  
  {
    echo "- [Ligne_$line_number]($current_file#L$line_number) : \`$safe_content\`"
  } >> "$OUTPUT_FILE"

done < "$TEMP_FILE"

echo "Extraction terminée : $TODO_COUNT TODO trouvé(s)."
echo "Fichier généré : $OUTPUT_FILE"
