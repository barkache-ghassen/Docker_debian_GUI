docker build --no-cache -t debian:latest .

docker run --rm -p 8080:8080 -p 5901:5901 debian:latest
