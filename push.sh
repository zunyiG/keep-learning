set -e

comments=$1
if [ -z $1 ]; then
  comments="_"
fi

git add -A
git commit -m $comments

git push
