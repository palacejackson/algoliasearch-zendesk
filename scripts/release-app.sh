#! /bin/sh

# Exit on error
set -e

# Ask for new version number if not in env
if [[ $ALGOLIASEARCH_ZENDESK_VERSION == "" ]]; then
  current=`git describe --abbrev=0 --tags`
  read -p "New version number (current is ${current}): " version
  export ALGOLIASEARCH_ZENDESK_VERSION=$version
fi

# Ask for confirmation
read -p "[App] We'll \`npm publish\` with \"v$ALGOLIASEARCH_ZENDESK_VERSION\". Continue (yn)? " -n 1 -r
echo
[[ $REPLY =~ ^[Yy]$ ]] || exit -1

# Build and publish app
cd app/
# No git-tag-version also disables the commit (See https://github.com/npm/npm/issues/7186)
npm version --no-git-tag-version $ALGOLIASEARCH_ZENDESK_VERSION
gulp clean
NODE_ENV=production gulp build
npm publish
cd ../