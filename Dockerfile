# Coq
# A Docker image for using Coq interactive theorem prover
#

FROM ocaml/opam:debian

# coq 8.4pl4 req 3.11.2 <= ocaml < 4.02
ARG OCAML_VER=4.01.0
ARG COQ_VER=8.4pl4
ARG OPAMJOBS=2
ARG OPAMVERBOSE=-v

# package description
LABEL name="coq" \
      version="3" \
      description="A Docker image for using Coq interactive theorem prover ${COQ_VER}" \
      coq_version="${COQ_VER}" \
      ocaml_version="${OCAML_VER}" \
      author="eldesh <nephits@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

USER root
WORKDIR /
# delete user [opam]; setup user [coq]
RUN useradd --create-home coq --shell /usr/bin/bash --groups sudo \
 && echo "coq:coq" | chpasswd \
 && echo 'coq ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/coq \
 && userdel --remove opam \
 && rm /etc/sudoers.d/opam

# switch user from [opam] to [coq]
USER coq
WORKDIR /home/coq
ENV HOME=/home/coq

# ocaml init script
COPY dot.ocamlinit /home/coq/.ocamlinit

# setup opam ; install coq
RUN opam init ${OPAMVERBOSE} --yes \
 && eval `opam config env` \
 && echo '# OPAM configuration' >> ~/.profile \
 && echo '. ~/.opam/opam-init/init.sh >/dev/null 2>&1 || true' >> ~/.profile \
 && opam switch ${OCAML_VER} ${OPAMVERBOSE} \
 && eval `opam config env` \
 && opam install ${OPAMVERBOSE} --yes coq.${COQ_VER}

CMD coqc --version

