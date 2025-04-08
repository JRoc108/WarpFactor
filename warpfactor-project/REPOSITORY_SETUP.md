# GitHub Repository Setup Guide

This document outlines the recommended structure and setup files for the WarpFactor GitHub repository owned by To Tech and Back, LTD.

## Root Directory Structure

```
warpfactor/
├── .github/                        # GitHub specific files
│   ├── workflows/                  # GitHub Actions
│   │   └── test.yml                # Testing workflow
│   ├── ISSUE_TEMPLATE/             # Issue templates
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── PULL_REQUEST_TEMPLATE.md    # PR template
├── docs/                           # Documentation
│   ├── WarpFactor_Configuration_Review.md
│   └── images/                     # Documentation images
├── scripts/                        # Additional utility scripts
│   └── install.sh                  # Optional installer
├── tests/                          # Test scripts
│   └── test_warpfactor.sh          # Basic test suite
├── .gitignore                      # Git ignore file
├── .editorconfig                   # Editor configuration
├── ATTRIBUTION.md                  # Credits and attributions
├── CHANGELOG.md                    # Version history
├── CODE_OF_CONDUCT.md              # Community guidelines
├── CONTRIBUTING.md                 # Contribution guidelines
├── LICENSE.md                      # MIT License with Churchman Rider I (Copyright © 2025 To Tech and Back, LTD.)
├── README.md                       # Project overview
└── warpfactor.sh                   # Main script
```

## File Creation Order

1. Create the basic directory structure:
```bash
mkdir -p .github/workflows .github/ISSUE_TEMPLATE docs/images scripts tests
```

2. Copy existing files to their appropriate locations:
```bash
cp warpfactor.sh ./
cp README.md ./
cp LICENSE.md ./
cp ATTRIBUTION.md ./
cp WarpFactor_Configuration_Review.md docs/
```

3. Create the additional files as outlined below.

## .gitignore File

Create a `.gitignore` file with the following content:

```
# macOS system files
.DS_Store
.AppleDouble
.LSOverride
Icon
._*
.Spotlight-V100
.Trashes

# Editor files
.idea/
.vscode/
*.sublime-project
*.sublime-workspace
*.swp
*.swo

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Test results
/test-results/
/playwright-report/
/playwright/.cache/

# Local configuration
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
```

## GitHub Actions Workflow

Create a file at `.github/workflows/test.yml`:

```yaml
name: Test WarpFactor Script

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  shellcheck:
    name: Shellcheck
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run ShellCheck
        uses: ludeeus/action-shellcheck@master
        with:
          scandir: './warpfactor.sh'
          
  syntax-check:
    name: Syntax Validation
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check bash syntax
        run: bash -n warpfactor.sh
      - name: Make script executable
        run: chmod +x warpfactor.sh
      - name: Verify script help output
        run: ./warpfactor.sh || test $? -eq 1
```

## Issue Templates

Create a bug report template at `.github/ISSUE_TEMPLATE/bug_report.md`:

```markdown
---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Run command '...'
2. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**System Information:**
 - macOS Version: [e.g. Sonoma 14.3]
 - Warp Terminal Version: [e.g. 0.2023.08.08.18.29]
 - Shell: [e.g. zsh 5.9]

**Additional context**
Add any other context about the problem here.
```

Create a feature request template at `.github/ISSUE_TEMPLATE/feature_request.md`:

```markdown
---
name: Feature request
about: Suggest an idea for this project
title: '[FEATURE] '
labels: enhancement
assignees: ''

---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is. Ex. I'm always frustrated when [...]

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
```

## Pull Request Template

Create a PR template at `.github/PULL_REQUEST_TEMPLATE.md`:

```markdown
## Description
Please include a summary of the changes and the related issue. Please also include relevant motivation and context.

Fixes # (issue)

## Type of change
Please delete options that are not relevant.

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## How Has This Been Tested?
Please describe the tests that you ran to verify your changes. Provide instructions so we can reproduce.

- [ ] Test A
- [ ] Test B

## Checklist:
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] Any dependent changes have been merged and published in downstream modules
```

## Additional Recommended Files

### CODE_OF_CONDUCT.md

Create a standard Code of Conduct file based on the [Contributor Covenant](https://www.contributor-covenant.org/).

### CONTRIBUTING.md

Create contribution guidelines explaining how others can contribute to the project:
- Setting up the development environment
- Running tests
- Style guide
- Pull request process
- Commit message format

### CHANGELOG.md

Start with:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-04-07

Copyright © 2025 To Tech and Back, LTD. Jared Churchman, Chief Engineer and sole owner.
### Added
- Initial release
- IncreaseWarpFactor function for system optimization
- DecreaseWarpFactor function to restore defaults
- Command-line interface support
- Comprehensive documentation
```

## Repository Settings

After creating the repository, apply these recommended settings:

1. **Description and topics**: Add a concise description and topics like `warp-terminal`, `macos`, `performance-optimization`, `terminal`
2. **Social Preview Image**: Create a banner image using the project name and rocket theme
3. **Branch Protection**: Set up protection on the main branch requiring pull request reviews
4. **Community Profile**: Complete all items in the community profile checklist
5. **GitHub Pages**: Enable GitHub Pages from the `docs` folder to publish documentation

## Getting Started

Once the repository is created, use the following commands to initialize it:

```bash
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: WarpFactor system optimization utility"

# Add remote to To Tech and Back, LTD. organization
git remote add origin https://github.com/TechAndBackLTD/warpfactor.git

# Push to GitHub
git push -u origin main
```

