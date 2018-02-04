# Coq
# A Docker image for using Coq interactive theorem prover
#

FROM ocaml/opam:debian

# coq 8.4.5 req 3.11.2 <= ocaml < 4.03
ARG OCAML_VER=4.02.3
ARG COQ_VER=8.4.5

# package description
LABEL name="coq" \
      version="1" \
      description="A Docker image for using Coq interactive theorem prover ${COQ_VER}" \
      coq_version="${COQ_VER}" \
      ocaml_version="${OCAML_VER}" \
      author="eldesh <nephits@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /coq

RUN opam switch ${OCAML_VER} \
 && eval `opam config env` \
 && opam install coq.${COQ_VER} --yes

CMD coqc

