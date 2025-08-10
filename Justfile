@help:
    just --list

# show some slides. E.g.: just present slides/cli.md [additional args]
@present *args:
    presenterm -x {{ args }}
