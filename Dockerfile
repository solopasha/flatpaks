ARG VERSION=42

FROM golang:alpine as tar-diff

RUN apk add --no-cache git && \
    git clone https://github.com/containers/tar-diff.git && \
    cd tar-diff && \
    git checkout f08980f165b5b4e50c466a695b906b9b28069c6c && \
    go build -o tar-diff ./cmd/tar-diff/



FROM registry.fedoraproject.org/fedora-minimal:$VERSION

RUN <<EOF cat > /etc/yum.repos.d/flatpak.repo
[copr:copr.fedorainfracloud.org:solopasha:flatpak-playground]
name=Copr repo for flatpak-playground owned by solopasha
baseurl=https://download.copr.fedorainfracloud.org/results/solopasha/flatpak-playground/fedora-\$releasever-\$basearch/devel/
type=rpm-md
skip_if_unavailable=False
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/solopasha/flatpak-playground/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
priority=1
EOF

COPY --from=tar-diff /go/tar-diff/tar-diff /usr/local/bin/tar-diff

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
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    useradd -m -u 1001 builduser

WORKDIR /home/builduser
USER builduser
