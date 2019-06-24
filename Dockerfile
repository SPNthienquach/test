FROM ubuntu
RUN /bin/bash -c 'echo hello'
ENV myCustomEnvVar="this is a sample"\
    otherCustomEnvVar="this is also a sample"
