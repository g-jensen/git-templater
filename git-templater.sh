#!/usr/bin/env bash

set -e

usage() {
    cat <<EOF
Usage: git-templater <command> [options]

Commands:
    list <template-repo>
        List all branches in the template repository

    apply <template-repo> <target-dir> [--strategy <strategy>] <branch...>
        Apply feature branches from template repo to target directory
    
    rebase
        Recursively rebase current branch onto all branches that depend on it.
        The dependencies of a branch are found in its .template-deps.yaml file.

Options:
    --strategy <strategy>    Git merge strategy option (e.g., theirs, ours, union)

Examples:
    git-templater list ./templates
    git-templater apply ./templates ./my-project auth_google auth_github
    git-templater apply ./templates ./my-project --strategy union auth_google
EOF
    exit 1
}

list_branches() {
    local template_repo="$1"
    
    if [[ ! -d "$template_repo/.git" ]]; then
        echo "Error: $template_repo is not a git repository"
        exit 1
    fi
    
    echo "Available branches in $template_repo:"
    echo
    git -C "$template_repo" branch -a | sed 's/^..//' | grep -v 'HEAD' | sort
}

apply_branches() {
    local template_repo="$1"
    local target_dir="$2"
    shift 2
    
    # Parse options
    local merge_strategy=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --strategy)
                merge_strategy="$2"
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done
    
    local branches=("$@")
    
    if [[ ! -d "$template_repo/.git" ]]; then
        echo "Error: $template_repo is not a git repository"
        exit 1
    fi
    
    if [[ ${#branches[@]} -eq 0 ]]; then
        echo "Error: No branches specified"
        usage
    fi
    
    # Get absolute path to template repo
    template_repo=$(cd "$template_repo" && pwd)
    
    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"
    cd "$target_dir"
    
    # Initialize git repo if needed
    if [[ ! -d ".git" ]]; then
        echo "Initializing git repository in $target_dir"
        git init
        git config user.name "Templater"
        git config user.email "templater@local"
        git commit --allow-empty -m "Initial commit"
    else
        # Check for dirty working tree
        if ! git diff --quiet || ! git diff --cached --quiet; then
            echo "Error: Target directory has uncommitted changes"
            echo "Commit or stash them before applying templates"
            exit 1
        fi
    fi
    
    # Add template repo as remote
    if git remote | grep -q "^templates$"; then
        git remote remove templates
    fi
    git remote add templates "$template_repo"
    
    # Fetch branches
    echo "Fetching branches from $template_repo"
    git fetch templates
    
    # Setup union merge attribute if needed (must be done BEFORE any merges)
    if [[ "$merge_strategy" == "union" ]]; then
        echo "Configuring union merge..."
        # Git has a built-in union merge attribute that runs diff3 and takes all unique lines
        echo "* merge=union" > .gitattributes
        git add .gitattributes
        git commit -m "Setup union merge" --allow-empty
    fi
    
    # Merge each branch
    for branch in "${branches[@]}"; do
        echo "Merging templates/$branch..."
        
        # Build merge command with optional strategy
        local merge_cmd="git merge --allow-unrelated-histories"
        if [[ -n "$merge_strategy" ]]; then
            # union is a merge driver (configured above via .gitattributes)
            # ours/theirs are strategy options for the recursive strategy
            if [[ "$merge_strategy" != "union" ]]; then
                merge_cmd="$merge_cmd -X $merge_strategy"
                echo "Using merge strategy option: $merge_strategy"
            else
                echo "Using merge strategy: $merge_strategy"
            fi
        fi
        merge_cmd="$merge_cmd templates/$branch -m \"Applied $branch\""
        
        if ! eval "$merge_cmd"; then
            echo "Error: Failed to merge $branch"
            echo "Conflicts detected. Resolve them manually or abort with: git merge --abort"
            exit 1
        fi
    done
    
    # Cleanup union merge attribute if it was set
    if [[ "$merge_strategy" == "union" ]]; then
        if [[ -f .gitattributes ]]; then
            git rm -f .gitattributes
            git commit -m "Remove union merge setup" --allow-empty
        fi
    fi
    
    echo
    echo "Successfully applied ${#branches[@]} feature(s)"
}

deps_of_branch() {
    local branch="$1"
    local deps_yaml
    deps_yaml=$(git show "${branch}:.template-deps.yaml" 2>/dev/null || true)
    if [[ -n "$deps_yaml" ]]; then
        echo "$deps_yaml" | grep "^  - " | sed 's/^  - //'
    fi
}

find_dependents_of() {
    local target="$1"
    shift
    local all_branches=("$@")
    local result=()
    for branch in "${all_branches[@]}"; do
        local dep
        for dep in $(deps_of_branch "$branch"); do
            if [[ "$dep" == "$target" ]]; then
                result+=("$branch")
                break
            fi
        done
    done
    echo "${result[@]}"
}

rebase_dependents() {
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    local all_branches=()
    while IFS= read -r b; do
        all_branches+=("$b")
    done < <(git branch --format='%(refname:short)')

    local queue=("$current_branch")
    local ordered=()
    local -A rebase_onto
    local visited=" ${current_branch} "

    while [[ ${#queue[@]} -gt 0 ]]; do
        local head="${queue[0]}"
        queue=("${queue[@]:1}")

        local deps
        read -ra deps <<< "$(find_dependents_of "$head" "${all_branches[@]}")"
        for dep in "${deps[@]}"; do
            if [[ -z "$dep" ]]; then continue; fi
            if [[ "$visited" != *" ${dep} "* ]]; then
                visited+="${dep} "
                ordered+=("$dep")
                rebase_onto["$dep"]="$head"
                queue+=("$dep")
            fi
        done
    done

    if [[ ${#ordered[@]} -eq 0 ]]; then
        echo "No branches depend on ${current_branch}"
        return 0
    fi

    for dep in "${ordered[@]}"; do
        local parent="${rebase_onto[$dep]}"
        echo "Rebasing ${dep} onto ${parent}"
        git rebase "${parent}" "${dep}"
    done

    git checkout "${current_branch}"
}

# Main
if [[ $# -lt 1 ]]; then
    usage
fi

command="$1"
shift

case "$command" in
    list)
        if [[ $# -ne 1 ]]; then
            usage
        fi
        list_branches "$1"
        ;;
    apply)
        if [[ $# -lt 3 ]]; then
            usage
        fi
        apply_branches "$@"
        ;;
    rebase)
        rebase_dependents
        ;;
    *)
        echo "Error: Unknown command '$command'"
        usage
        ;;
esac
