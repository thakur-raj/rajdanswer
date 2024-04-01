FROM gitpod/workspace-full

USER root

# Download the Ollama binary
RUN curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/bin/ollama \
    && chmod +x /usr/bin/ollama

# Create a user for Ollama
RUN useradd -r -s /bin/false -m -d /usr/share/ollama ollama

# Create a service file
RUN echo '[Unit]\n\
Description=Ollama Service\n\
After=network-online.target\n\
\n\
[Service]\n\
ExecStart=/usr/bin/ollama serve\n\
User=ollama\n\
Group=ollama\n\
Restart=always\n\
RestartSec=3\n\
\n\
[Install]\n\
WantedBy=default.target' > /etc/systemd/system/ollama.service

# Start the service
RUN systemctl daemon-reload \
    && systemctl enable ollama

USER gitpod
