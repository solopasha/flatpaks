ARG VERSION=42

FROM registry.fedoraproject.org/fedora-minimal:$VERSION

RUN rm /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    dnf -y up && dnf -y install --setopt=install_weak_deps=False \
        ccache \
        flatpak-builder \
        git-core \
        patch \
        skopeo \
        tar \
        zstd && \
    dnf clean all && \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    useradd -M -u 1001 builduser && \
    mkdir /build && \
    chown builduser:builduser /build && \
    setcap cap_setuid=ep /usr/bin/newuidmap && \
    setcap cap_setgid=ep /usr/bin/newgidmap

WORKDIR /build
USER builduser
