#!/bin/sh

set -e
set -x

if [ -z "$INPUT_SOURCE_FILE" ]
then
  echo "Source file must be defined"
  return -1
fi

if [ -z "$INPUT_SOURCE_BRANCH" ]
then
  INPUT_SOURCE_BRANCH=master
fi
OUTPUT_BRANCH_S="$INPUT_SOURCE_BRANCH"

if [ -z "$INPUT_DESTINATION_BRANCH" ]
then
  INPUT_DESTINATION_BRANCH=master
fi
OUTPUT_BRANCH_D="$INPUT_DESTINATION_BRANCH"

CLONE_DIR_S=$(mktemp -d)
CLONE_DIR_D=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"
git clone --single-branch --branch $INPUT_SOURCE_BRANCH "https://x-access-token:$API_TOKEN_GITHUB@github.com/$INPUT_SOURCE_REPO.git" "$CLONE_DIR_S"
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://x-access-token:$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR_D"

echo "Copying contents to git repo"
mkdir -p $CLONE_DIR_D/$INPUT_DESTINATION_FOLDER
cp -R "$CLONE_DIR_S/$INPUT_SOURCE_FILE" "$CLONE_DIR_D/$INPUT_DESTINATION_FOLDER"
cd "$CLONE_DIR_D"

if [ ! -z "$INPUT_DESTINATION_BRANCH_CREATE" ]
then
  git checkout -b "$INPUT_DESTINATION_BRANCH_CREATE"
  OUTPUT_BRANCH_D="$INPUT_DESTINATION_BRANCH_CREATE"
fi

if [ -z "$INPUT_COMMIT_MESSAGE" ]
then
  INPUT_COMMIT_MESSAGE="Update from https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}"
fi

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MESSAGE"
  echo "Pushing git commit"
  git push -u origin HEAD:$OUTPUT_BRANCH_D
else
  echo "No changes detected"
fi