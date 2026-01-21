# git-templater Acceptance Tests

Comprehensive acceptance test suite for the `git-templater.sh` CLI tool using Basanos.

## Running Tests

```bash
# Run all tests
basanos -s spec

# Run specific context
basanos -s spec/usage
basanos -s spec/apply
basanos -s spec/list

# Run with verbose output
basanos -s spec -v
```

## Test Organization

The test suite is organized by functional area:

### `usage/`
Tests for command-line interface and help output:
- No arguments shows usage
- Unknown commands show errors
- Missing required arguments
- Invalid argument combinations

### `list/`
Tests for the `list` command:
- Listing branches in a template repository
- Error handling for non-git directories
- Filtering and sorting of branch names
- Excluding HEAD from output

### `apply/`
Tests for the `apply` command:
- Applying single and multiple feature branches
- Initializing new target directories
- Working with existing git repositories
- Detecting uncommitted changes
- Handling hierarchical branch structures

### `merge_strategy/`
Tests for the `--strategy` option:
- Union strategy for combining changes
- Theirs/ours strategies for conflict resolution
- Flag positioning and parsing

### `edge_cases/`
Tests for boundary conditions:
- Nonexistent branches
- Relative vs absolute paths
- Applying master branch explicitly
- Remote cleanup and re-adding
- Directory creation

### `conflicts/`
Tests for merge conflict scenarios:
- Unresolvable conflicts
- Partial application on conflict
- Error messages and recovery instructions

## Helper Scripts

The `helpers/` directory contains setup scripts used by tests:

- `init-template-repo.sh` - Initialize basic template repository
- `create-feature-branch.sh` - Create a feature branch with a file
- `init-target-repo.sh` - Initialize target directory with existing work
- `make-dirty.sh` - Add uncommitted changes to target repo
- `setup-multi-feature.sh` - Create repo with multiple independent features
- `setup-hierarchical.sh` - Create repo with parent/child branches
- `setup-conflicting.sh` - Create repo with auto-mergeable conflicts
- `setup-conflicting-unmergeable.sh` - Create repo with real conflicts

## Test Coverage

The test suite covers:

**Happy Path:**
- ✅ Listing branches
- ✅ Applying single branch
- ✅ Applying multiple branches
- ✅ Working with hierarchical branches
- ✅ Using merge strategies

**Error Conditions:**
- ✅ Non-git directories
- ✅ Missing arguments
- ✅ Invalid commands
- ✅ Nonexistent branches
- ✅ Dirty working tree
- ✅ Merge conflicts

**Edge Cases:**
- ✅ Relative paths
- ✅ Empty target directories
- ✅ Existing git repositories
- ✅ Remote re-configuration
- ✅ Complex branch names (with slashes)

## Observable Behaviors Tested

All tests verify **user-observable behavior** through:
- Command exit codes
- Standard output messages
- Standard error messages
- File system state (files created/modified)
- Git repository state

Tests do NOT peek into:
- Internal git objects
- Implementation details
- Database state (none in this tool)

## Environment Variables

Tests use these environment variables (defined in root `context.yaml`):

- `TEMPLATER` - Path to git-templater.sh script
- `HELPERS` - Path to helper scripts directory
- `TEST_TMP` - Temporary directory for test artifacts
- `TEMPLATE_REPO` - Path to template repository during tests
- `TARGET_DIR` - Path to target directory during tests

## Cleanup

All tests clean up after themselves:
- `before_each` removes and recreates test directories
- `after` hook removes entire test temp directory
- Tests are fully isolated - no shared state between scenarios
