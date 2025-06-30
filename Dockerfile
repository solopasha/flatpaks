ARG VERSION=42

FROM registry.fedoraproject.org/fedora-minimal:$VERSION

RUN rm /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    dnf -y up && dnf -y install --setopt=install_weak_deps=False \
        bzip2 \
        ccache \
        flatpak-builder \
        git-core \
        patch \
        skopeo \
        tar \
        zstd && \
    dnf clean all && \
    useradd -m -u 1001 builduser

WORKDIR /home/builduser
USER builduser
