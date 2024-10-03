# Docker Assignment

This project is a simple Node.js application that serves a static HTML page with some links. The application code is located in the `app` directory.

## Assignment
Your task is to create a `Dockerfile` that builds and runs the Node.js application.

### Dockerfile Requirements:
1. The **base layer** should be based on the `node:20` image.
2. The final image should only include:
   - `app.js`
   - `package.json`
   - `views` directory 
   These should be copied to `/usr/src/app` inside the container.
3. The application should be started with the following **entrypoint**: `node ./app.js`.
4. The container image should support both **amd64** and **arm64** architectures and be **pushed to Docker Hub**.

### Grading Rubric:

| Objectives                                                       | Points |
|------------------------------------------------------------------|--------|
| Final stage based on `node:20-alpine`                             | 2      |
| Final image only includes `app.js`, `package.json`, and `views`   | 5      |
| Entry point starts the app with `node app.js`                     | 2      |
| Push multi-architecture image to Docker Hub                      | 3      |

---

## Pre-requisites

Before you begin, ensure the following are installed:

- **Docker**: Download from [here](https://www.docker.com/products/docker-desktop).
- **Docker Hub Account**: If you don’t have one, [create one](https://hub.docker.com/signup).
   - Your Docker Hub repository name should match your Docker Hub username.
- **Git**: Download from [here](https://git-scm.com/downloads).
- **Web Browser**: Ensure you have a web browser installed for testing the application.

---

## Dockerfile RUN Commands

To install dependencies for the Node.js application, the base image will handle installing the Node.js runtime. You only need to run the `npm install` command during the build process.

---

## Building an Image for Your Local Machine

To build the Docker image for your local machine, run the following command:

```bash
# Build the image locally
docker build -t [YOUR DOCKER HUB REPO]/cs1660-assignment2:v1 .
```

---

## Testing the Image

To test that your image works, run the container with the following command and visit `http://localhost:5000` in your browser to verify the application is running. If a web page renders, you're ready to submit the assignment. Assuming you have pushed your image to DockerHub.

```bash
docker run -p 5000:5000 -it --rm --name app [YOUR DOCKER HUB REPO]/cs1660-assignment2:v1
```

---

## Building the Multi-Architecture Image

We need to support both `amd64` and `arm64` architectures by using Docker's `buildx` feature.

### Enabling `buildx`:

Run the following command to create a builder instance that supports both platforms:

```bash
# Create a builder instance with arm64 and amd64 platforms
docker buildx create --use --platform=linux/arm64,linux/amd64 --name multi-platform-builder

# verify your new buildx builder
docker buildx ls
```

### Building and Pushing the Image:

To build and push the multi-architecture image to Docker Hub, run the following command:

```bash
# Build and push multi-architecture image to Docker Hub
docker buildx build --push --platform linux/amd64,linux/arm64 -t [YOUR DOCKER HUB REPO]/cs1660-assignment2:v1 .
```

---

## Submission Instructions

1. **Merge your code** into the **main** branch of the GitHub project.
2. **Create a Docker Hub repository** named `[your dockerhub username]/cs-1660-assignment2` following the [Docker Hub Quickstart](https://docs.docker.com/docker-hub/quickstart/).
3. **Push your multi-architecture image** to the `[your dockerhub username]/cs-1660-assignment2` repository.
4. **Submit your Docker Hub repository name** on Canvas. It should look like `[dockerhub username]/cs-1660-assignment2`.

---

## Docker Login

You will need to authenticate to DockerHub before you can push.

Login to Docker Hub by running the following command in your terminal:

```bash
# Log in to Docker Hub (you will be prompted for your password)
docker login --username=[DOCKER HUB LOGIN]
```

This will store your credentials in `~/.docker/config.json`.

---

## Resources

- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [Docker Buildx Create](https://docs.docker.com/engine/reference/commandline/buildx_create/)
- [Docker Buildx Build](https://docs.docker.com/engine/reference/commandline/buildx_build/)
- [Docker CLI reference](https://docs.docker.com/reference/cli/docker/)
