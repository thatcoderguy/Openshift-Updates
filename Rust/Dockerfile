FROM openshift/base-centos7

# This image provides a Rust environment you can use to run your Rust
# applications.

EXPOSE 8080

ENV RUST_VERSION 1.57

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.57.0

LABEL io.k8s.description="Platform for building and running Rust 1.57 applications" \
      io.k8s.display-name="Rust 1.57.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,rust,rust157"

RUN yum install -y yum-utils && \
    yum install -y centos-release-scl && \
        yum install -y curl && \
    yum clean all -y

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s - -y
RUN chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
