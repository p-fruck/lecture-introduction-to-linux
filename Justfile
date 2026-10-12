@help:
    just --list

# show some slides. E.g.: just present slides/cli.md [additional args]
@present *args:
    presenterm -c config.yaml -x {{ args }}

[group('build')]
@export-all:
    ./scripts/export.sh

[group('build')]
@nginx:
    podman run --rm -v ./_site/:/usr/share/nginx/html:ro,z -p 8080:8080 nginxinc/nginx-unprivileged:alpine
