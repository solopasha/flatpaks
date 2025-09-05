ARG VERSION=42

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

RUN rm /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    dnf -y up && dnf -y install --setopt=install_weak_deps=False \
        bzip2 \
        dbus-daemon \
        flatpak-builder \
        git-core \
        jq \
        patch \
        skopeo \
        tar \
        zstd && \
    dnf clean all && \
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    useradd -m -u 1001 builduser

WORKDIR /home/builduser
USER builduser
