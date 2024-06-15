# Docker image

This is a docker image definition for our application.

### Notes

* If want to test building a docker image on linux, do not install docker via `snap`, follow the docker documentation instead
* The newer docker versions have progress text hidden, you can pass `--progress plain` to the build command to get normal logging

### Testing under linux

* Docker installation instructions - https://docs.docker.com/engine/install/ubuntu/
* To build: `sudo docker build --progress plain -t ds24app .`
* To run: `sudo docker run ds24app`

### Testing under OSX with Apple Silicon

* To run docker under Apple Silicon, download and install Docker Desktop from the website https://www.docker.com/products/docker-desktop/
  - After installing, run Docker from Applications 1 time
  - Install Rosette if it prompts you to
* From the command line you can now use `docker build --platform linux/amd64 --progress plain -t ds24app .`
* You also need to pass `--platform linux/amd64` when testing `docker run`
