#!/bin/bash
# This is script is simply a shortcut to the pre-commit hook command that I always forget when I clone this repo.
# The pre-commit hook in ./hooks will automatically run terraform fmt on all terraform files in the repo.
git config set core.hooksPath ./hooks