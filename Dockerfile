# Coq
# A Docker image for using Coq interactive theorem prover
#

FROM ocaml/opam:debian

# coq 8.5.3 req 3.12.1 <= ocaml < 4.06.0
ARG OCAML_VER=4.05.0
ARG COQ_VER=8.5.3

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

