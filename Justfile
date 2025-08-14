@help:
    just --list

# show some slides. E.g.: just present slides/cli.md [additional args]
@present *args:
    presenterm -x {{ args }}

[group('build')]
@export-all *args:
    rm -rf _site && mkdir _site
    echo '# Introduction to Linux' > _site/index.md
    echo -e '\nYou can view or download the latest slides here:\n' >> _site/index.md
    for file in slides/*.md; do \
        echo $file; \
        name=$(basename "${file}" | cut -d . -f 1); \
        echo "- ${name} [[html](${name}.html)][[pdf](${name}.pdf)]" >> _site/index.md; \
        presenterm --export-pdf --output _site/${name}.pdf ${file} {{ args }}; \
        presenterm --export-html --output _site/${name}.html ${file} {{ args }}; \
    done
    pandoc _site/index.md -o _site/index.html
