FROM debian:bookworm-slim

# Add Thorium apt repo
RUN apt-get update && apt-get install -y wget ca-certificates --no-install-recommends \
    && rm -fv /etc/apt/sources.list.d/thorium.list \
    && wget --no-hsts -P /etc/apt/sources.list.d/ http://dl.thorium.rocks/debian/dists/stable/thorium.list \
    && apt-get update \
    && apt-get install -y \
        thorium-browser \
        fonts-liberation \
        fonts-noto \
        libgtk-3-0 \
        libasound2 \
        libgbm1 \
        --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash browser
USER browser
WORKDIR /home/browser

# Startpage as default search engine via preferences
RUN mkdir -p /home/browser/.config/thorium/Default
COPY --chown=browser:browser preferences /home/browser/.config/thorium/Default/Preferences

CMD ["thorium-browser", "--no-sandbox", "--enable-wayland-ime", \
     "--ozone-platform=wayland", "MOZ_ENABLE_WAYLAND=1"]
