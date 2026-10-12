#!/usr/bin/env bash
set -eu

export_all() {
    dir=$1
    echo "| Title | HTML | PDF |" >> _site/index.md
    echo "|:----- |:----:|:---:|" >> _site/index.md
    for file in slides/*.md; do
        echo "${file}"
        name=$(basename "${file}" | cut -d . -f 1)
        echo "| ${name} | [[dark](${dir}/dark/${name}.html)] [[light](${dir}/light/${name}.html)] | [[dark](${dir}/dark/${name}.pdf)] [[light](${dir}/light/${name}.pdf)] |" >> _site/index.md
        presenterm -x -c config.yaml --export-pdf --output "_site/${dir}/dark/${name}.pdf" "${file}"
        presenterm -x -c config.yaml --export-html --output "_site/${dir}/dark/${name}.html" "${file}"
        sed -i 's/dhbw_mannheim_dark\.yml/dhbw_mannheim_light.yml/' "${file}"
        presenterm -x -c config.yaml --export-pdf --output "_site/${dir}/light/${name}.pdf" "${file}"
        presenterm -x -c config.yaml --export-html --output "_site/${dir}/light/${name}.html" "${file}"
    done
}

cd "$(dirname "$0")/.."
rm -rf _site && mkdir -p _site/{compact,extended}/{dark,light}
echo '# Introduction to Linux

You can view or download the latest slides here.
' > _site/index.md

echo "## Compact" >> _site/index.md
echo "Single page per slide" >> _site/index.md
export_all compact
git restore slides

echo "## Extended" >> _site/index.md
echo "One page for each animation" >> _site/index.md
yq -yi '.export.pauses = "new_slide"' config.yaml
export_all extended

git restore slides config.yaml
pandoc _site/index.md -o _site/index.html -s
