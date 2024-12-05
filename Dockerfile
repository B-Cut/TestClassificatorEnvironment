FROM alpine


ARG git_private_ssh_key=""
ARG git_public_ssh_key=""

RUN apk add --no-cache jq libtool lsblk git openssh-client openjdk21-jre-headless maven bash make nodejs nodejs-dev apache-ant gcompat libaio-dev openssl-dev apr-dev lksctp-tools-dev lksctp-tools libtool automake autoconf
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN echo "${git_private_ssh_key}" > ~/.ssh/id_ed25519 && chmod 700 ~/.ssh/id_ed25519 
RUN echo "${git_public_ssh_key}}" > ~/.ssh/id_ed25519.pub && chmod 700 ~/.ssh/id_ed25519.pub


WORKDIR /classify
COPY . /classify
RUN pwd
RUN ls -al
RUN chmod +x run_classificator.sh


# ========================================================================================================== #
#                                                                                                            #
# WARNING, ANYONE THAT HAS ACCESS TO THIS IMAGE WILL COULD GET ACCESS TO THE SSH KEY PASSED, BE CAREFUL      #
#                                                                                                            #
# unfortunately this is the quickest way to do this operation                                                #
#                                                                                                            #            
# ========================================================================================================== #


ENTRYPOINT [ "/bin/bash", "run_classificator.sh" ]

