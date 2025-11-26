#!/bin/bash

# Set user to web3challenger
export USER=web3challenger
export HOME=/home/web3challenger

# Fix TigerVNC migration
mkdir -p $HOME/.config/tigervnc
chown -R $USER:$USER $HOME/.config

# Ensure VNC folder exists
mkdir -p $HOME/.vnc
chown -R $USER:$USER $HOME/.vnc

# Create xstartup
cat << 'EOF' > $HOME/.vnc/xstartup
#!/bin/bash
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=1
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x $HOME/.vnc/xstartup
chown $USER:$USER $HOME/.vnc/xstartup

# Set VNC password
echo "password" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd
chown $USER:$USER $HOME/.vnc/passwd

# Kill old VNC session
vncserver -kill :1 >/dev/null 2>&1 || true

# Start VNC
export DISPLAY=:1
export QT_AUTO_SCREEN_SCALE_FACTOR=1

exec gosu web3challenger bash <<'EOS'
# Commands here run as web3challenger
cd $HOME || exit 1
vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes None
websockify --web=/usr/share/novnc/ 0.0.0.0:8080 127.0.0.1:5901
wait
EOS

