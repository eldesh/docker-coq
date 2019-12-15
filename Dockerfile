# Coq
# A Docker image for using Coq interactive theorem prover
#

FROM ocaml/opam2:debian-stable

# coq 8.8.1 req 4.02.3 <= ocaml
ARG OCAML_VER=4.05.0
ARG COQ_VER=8.8.1
ARG OPAMJOBS=2
ARG OPAMVERBOSE=1

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
RUN userdel --remove opam \
 && rm /etc/sudoers.d/opam \
 && groupadd --gid 1000 coq \
 && useradd --create-home --shell /usr/bin/bash \
      --groups sudo --uid 1000 --gid 1000 coq \
 && echo "coq:coq" | chpasswd \
 && echo 'coq ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/coq

# switch user from [opam] to [coq]
USER coq
WORKDIR /home/coq
ENV HOME=/home/coq

# ocaml init script
COPY dot.ocamlinit /home/coq/.ocamlinit

# setup opam ; install coq
RUN sudo apt-get install -y m4 \
 # generate nosandbox command
 && echo 'wrap-build-commands: []'    > ~/.opamrc-nosandbox \
 && echo 'wrap-install-commands: []' >> ~/.opamrc-nosandbox \
 && echo 'wrap-remove-commands: []'  >> ~/.opamrc-nosandbox \
 && echo 'required-tools: []'        >> ~/.opamrc-nosandbox \
 # generate sandbox command
 && echo 'wrap-build-commands  : ["%{hooks}%/sandbox.sh" "build"]'    > ~/.opamrc-sandbox \
 && echo 'wrap-install-commands: ["%{hooks}%/sandbox.sh" "install"]' >> ~/.opamrc-sandbox \
 && echo 'wrap-remove-commands : ["%{hooks}%/sandbox.sh" "remove"]'  >> ~/.opamrc-sandbox \
 # disable sandbox
 && opam-sandbox-disable \
 # setup opam
 && opam init --yes \
 && eval `opam env` \
 # generate opam configuration
 && sudo chown coq:coq ~/.ocamlinit \
 && echo '# OPAM configuration' >> ~/.profile \
 && echo '. ~/.opam/opam-init/init.sh >/dev/null 2>&1 || true' >> ~/.profile \
 # switch to specific ocaml
 && opam switch create ${OCAML_VER} \
 && eval `opam env` \
 # setup coq repository
 && opam repo add official https://opam.ocaml.org/ \
 && opam repo add coq-release http://coq.inria.fr/opam/released \
 # install coq
 && opam pin add coq ${COQ_VER}

CMD coqc --version

