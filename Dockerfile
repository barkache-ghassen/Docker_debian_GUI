#Base image debian 
FROM debian:13

# Installing GUI and noVNC 
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server tigervnc-common tigervnc-tools \
    novnc websockify \
    x11-xserver-utils dbus-x11 xfonts-base \
    curl wget git nano sudo gosu \
    fonts-dejavu fonts-liberation \ 
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash web3challenger && \
    passwd -d web3challenger

COPY web3_bg.png /home/web3challenger/


# Create VNC directory for user
RUN mkdir -p /home/web3challenger/.vnc && \
    echo "#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &" \
    > /home/web3challenger/.vnc/xstartup && \
    chmod +x /home/web3challenger/.vnc/xstartup && \
    chown -R web3challenger:web3challenger /home/web3challenger

#Create XFCE4 Config for better icon rendering
RUN mkdir -p /home/web3challenger/.config/xfce4/xfconf/xfce-perchannel-xml
COPY xsettings.xml /home/web3challenger/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
RUN chown -R web3challenger:web3challenger /home/web3challenger/.config


COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh
COPY change_user.sh /root/change_user.sh
RUN chmod +x /root/change_user.sh


COPY web3_bg.png /home/web3challenger/
RUN chown -R web3challenger:web3challenger /home/web3challenger/web3_bg.png

# Expose VNC + noVNC ports
EXPOSE 5901 8080

CMD ["/root/start.sh"]

