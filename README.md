# swagger-codegen

A wrapper around [swagger-api/swagger-codegen](https://github.com/swagger-api/swagger-codegen) that extends it with additional code generators and provides convenience scripts for building and generating code from OpenAPI/Swagger YAML definitions.

## Overview

This project extends the official swagger-codegen tool with custom language generators:

- **php-symfony** – PHP Symfony server stub generator
- **php** – PHP client generator
- **qt5cpp** – Qt5 C++ client generator

It also provides scripts to simplify the build, initialization, and code-generation workflow, and a Docker image for running the tool in CI/CD pipelines.

## Prerequisites

- **Java** (JDK) – required to run the swagger-codegen JAR
- **Maven** – required to build the project (or Docker if using `--use-docker`)
- **Git** – required to manage submodules
- **wget** – required by the `install-choco-scripts.sh` installer
- **Docker** *(optional)* – required for building/running via Docker
- **[choco-scripts](https://github.com/JohnAmadis/choco-scripts)** – shell scripting framework used by all provided scripts

## Installation

### 1. Install choco-scripts

All scripts in this repository depend on the [choco-scripts](https://github.com/JohnAmadis/choco-scripts) framework. Install it by running:

```bash
./install-choco-scripts.sh
source ~/.bashrc
```

### 2. Initialize the repository

Fetch the upstream swagger-codegen submodule, apply the custom generators, and build the JAR:

```bash
./initialize.sh
```

To build using Docker instead of a local Maven installation:

```bash
./initialize.sh --use-docker
```

After a successful build the compiled JAR will be available at:

```
repository/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar
```

## Usage

### Generating code

Use the `generate.sh` script to generate a REST server or client from an OpenAPI/Swagger YAML file:

```bash
./generate.sh --module <module> --input <yaml-file> --target-path <output-dir>
```

#### Arguments

| Argument | Short | Required | Default | Description |
|---|---|---|---|---|
| `--module` | `-m` | No | `php-symfony` | Generator module to use (`php-symfony`, `php`, `qt5cpp`) |
| `--input` | `-i` | **Yes** | – | Path to the OpenAPI/Swagger YAML definition file |
| `--target-path` | `-t` | **Yes** | – | Directory where the generated code will be placed |
| `--jar` | | No | `repository/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar` | Path to a pre-compiled swagger-codegen JAR |
| `--options` | `-o` | No | *(empty)* | Additional parameters passed directly to the swagger-codegen command |

#### Examples

Generate a PHP Symfony server:

```bash
./generate.sh --module php-symfony --input api/openapi.yaml --target-path output/server
```

Generate a Qt5 C++ client:

```bash
./generate.sh --module qt5cpp --input api/openapi.yaml --target-path output/client
```

### Generating API documentation only

Use the `generate_docs.sh` script to generate only the API documentation (Markdown files) from an OpenAPI/Swagger YAML file, without generating any server or client code:

```bash
./generate_docs.sh --module <module> --input <yaml-file> --target-path <output-dir>
```

#### Arguments

| Argument | Short | Required | Default | Description |
|---|---|---|---|---|
| `--module` | `-m` | No | `php-symfony` | Generator module to use (`php-symfony`, `php`) |
| `--input` | `-i` | **Yes** | – | Path to the OpenAPI/Swagger YAML definition file |
| `--target-path` | `-t` | **Yes** | – | Directory where the generated documentation will be placed |
| `--jar` | | No | `repository/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar` | Path to a pre-compiled swagger-codegen JAR |
| `--options` | `-o` | No | *(empty)* | Additional parameters passed directly to the swagger-codegen command |

#### Example

Generate API documentation for a PHP Symfony project:

```bash
./generate_docs.sh --module php-symfony --input api/openapi.yaml --target-path output/docs
```

## Docker

### Building the Docker image

After running `./initialize.sh`, build and publish the Docker image with:

```bash
./build.sh --version <version>
```

#### Arguments

| Argument | Short | Required | Default | Description |
|---|---|---|---|---|
| `--version` | `-v` | **Yes** | – | Version tag for the Docker image |
| `--repository` | `-r` | No | `chocotechnologies` | DockerHub repository name |
| `--image-name` | `-i` | No | `swagger-codegen` | Name of the Docker image |

#### Example

```bash
./build.sh --version 1.0.0
```

This builds and pushes `chocotechnologies/swagger-codegen:1.0.0` and `chocotechnologies/swagger-codegen:latest` to DockerHub.

### Running code generation with Docker

When using the pre-built Docker image, the `generate` alias is available inside the container:

```bash
docker run --rm \
  -v "$(pwd)/api:/api" \
  -v "$(pwd)/output:/output" \
  chocotechnologies/swagger-codegen \
  generate --module php-symfony --input /api/openapi.yaml --target-path /output
```

## CI/CD

The repository includes a `bitbucket-pipelines.yml` configuration. Pushing a tag matching the pattern `V.*` (e.g. `V.1.2.3`) automatically:

1. Logs in to DockerHub using `$DOCKER_USERNAME` and `$DOCKER_PASSWORD` pipeline variables.
2. Installs choco-scripts.
3. Initializes and builds the project.
4. Builds and publishes the Docker image tagged with the version from the Git tag.

## Project Structure

```
.
├── modules/                  # Custom swagger-codegen language generators
│   └── swagger-codegen/
│       └── src/main/
│           ├── java/         # Java generator implementations
│           └── resources/    # Mustache templates for each language
├── repository/               # Git submodule – upstream swagger-api/swagger-codegen
├── Dockerfile                # Docker image definition
├── build.sh                  # Builds and publishes the Docker image
├── generate.sh               # Generates code from an OpenAPI YAML file
├── generate_docs.sh          # Generates only API documentation from an OpenAPI YAML file
├── initialize.sh             # Initializes the repo and builds the JAR
├── install-choco-scripts.sh  # Installs the choco-scripts framework
├── task-configuration.sh     # Project-level configuration variables
└── bitbucket-pipelines.yml   # Bitbucket Pipelines CI/CD configuration
```
