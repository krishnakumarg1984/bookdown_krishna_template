#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "krishnak@vt.edu"
git config --global user.name "Krishnakumar Gopalakrishnan"

git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git report-output
cd report-output

ls | xargs rm -rf
git ls-files --deleted -z | xargs -0 git rm

cp -r ../_book/* ./
git add --all *
git commit -m "Update the report" || true
git reset $(git commit-tree HEAD^{tree} -m "Update the book")
git push -q origin gh-pages
