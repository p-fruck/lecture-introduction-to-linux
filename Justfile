@help:
    just --list

# show some slides. E.g.: just present slides/cli.md [additional args]
@present *args:
    presenterm -x {{ args }}

[group('build')]
@export-all:
    rm -rf _site/*
    echo '# Introduction to Linux' > _site/index.md
    echo 'You can view or download the latest slides here:' >> _site/index.md
    for file in slides/*.md; do \
        echo $file; \
        name=$(basename "${file}" | cut -d . -f 1); \
        echo "- ${name} [[html](${name}.html)][[pdf](${name}.pdf)]" >> _site/index.md; \
        presenterm --export-pdf --output _site/${name}.pdf ${file}; \
        presenterm --export-html --output _site/${name}.html ${file}; \
    done
