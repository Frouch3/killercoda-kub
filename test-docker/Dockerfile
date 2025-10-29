FROM ubuntu:22.04

# Simuler l'environnement Killercoda
ENV DEBIAN_FRONTEND=noninteractive

# Installer les outils de base (comme dans Killercoda)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    vim \
    git \
    && rm -rf /var/lib/apt/lists/*

# Créer le répertoire de travail
WORKDIR /root

# Copier les scripts de test
COPY setup.sh /root/setup.sh
COPY foreground.sh /root/foreground.sh
COPY verify-step1.sh /root/verify-step1.sh

# Rendre les scripts exécutables
RUN chmod +x /root/*.sh

# Par défaut, lancer un bash interactif
CMD ["/bin/bash"]
