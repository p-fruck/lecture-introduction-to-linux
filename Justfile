@help:
    just --list

# show some slides. E.g.: just present slides/cli.md [additional args]
@present *args:
    presenterm -x {{ args }}

[group('build')]
@export-all *args:
    rm -rf _site && mkdir -p _site/dark _site/light
    echo '# Introduction to Linux' > _site/index.md
    echo -e '\nYou can view or download the latest slides here:\n' >> _site/index.md
    echo "| Title | HTML | PDF |" >> _site/index.md
    echo "|:----- |:----:|:---:|" >> _site/index.md
    for file in slides/*.md; do \
        echo $file; \
        name=$(basename "${file}" | cut -d . -f 1); \
        echo "| ${name} | [[dark](dark/${name}.html)] [[light](light/${name}.html)] | [[dark](dark/${name}.pdf)] [[light](light/${name}.pdf)] |" >> _site/index.md; \
        presenterm -x -c config.yaml --export-pdf --output _site/dark/${name}.pdf ${file} {{ args }}; \
        presenterm -x -c config.yaml --export-html --output _site/dark/${name}.html ${file} {{ args }}; \
        sed -i 's/dhbw_mannheim_dark\.yml/dhbw_mannheim_light.yml/' "${file}"; \
        presenterm -x -c config.yaml --export-pdf --output _site/light/${name}.pdf ${file} {{ args }}; \
        presenterm -x -c config.yaml --export-html --output _site/light/${name}.html ${file} {{ args }}; \
    done
    pandoc _site/index.md -o _site/index.html -s
