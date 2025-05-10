# `--platform` argument is used to be able to build docker images when using another platform (e.g. Apple M1)
FROM --platform=linux/x86_64 scratch AS first_stage

ARG FOO

ENV FOO $FOO

COPY empty /empty

FROM first_stage AS second_stage

COPY empty /empty_two
