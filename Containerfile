# Use a recent Fedora base image
FROM registry.fedoraproject.org/fedora:latest

# Install Node.js (e.g., LTS version like 20), npm, and system dependencies
# required by Mermaid CLI (especially for Puppeteer/Chromium for PNG/PDF output).
# - dnf clean all: Cleans up metadata and package files to reduce image size.
# - chromium: The browser for Puppeteer.
# - alsa-lib, nss, libXScrnSaver, cups-libs, libxshmfence, at-spi2-atk, GConf2: Dependencies for Chromium.
# - google-noto-sans-fonts: Good general-purpose fonts.
# - git, ca-certificates: Generally useful.

RUN dnf install -y \
    nodejs20 \
    # Alternatively, for the latest available Node.js stream:
    # nodejs \
    npm \
    chromium \
    alsa-lib \
    nss \
    libXScrnSaver \
    cups-libs \
    libxshmfence \
    at-spi2-atk \
    GConf2 \
    google-noto-sans-fonts \
    git \
    ca-certificates && \
    dnf clean all

# Tell Puppeteer to use the system-installed Chromium.
# Fedora typically installs it as /usr/bin/chromium-browser.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install Mermaid CLI globally using npm.
# Puppeteer is a peer dependency for mmdc for PNG/PDF generation.
# The --unsafe-perm flag can be necessary for global npm installs in some container environments.
RUN npm install -g @mermaid-js/mermaid-cli puppeteer --unsafe-perm

# Set the working directory inside the container.
WORKDIR /diagrams

# Set the entrypoint to mmdc.
ENTRYPOINT ["mmdc"]
