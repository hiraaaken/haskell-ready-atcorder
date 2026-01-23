# Haskell development environment for AtCoder problem fetcher
# Based on official Haskell image with GHC 9.4 (AtCoder compatible)

FROM haskell:9.4

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libz-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy stack configuration first for better caching
COPY stack.yaml stack.yaml.lock* package.yaml ./

# Download dependencies (cached layer)
RUN stack setup --install-ghc
RUN stack build --only-dependencies --test --no-run-tests || true

# Copy source code
COPY . .

# Build the project
RUN stack build --test --no-run-tests

# Default command
CMD ["stack", "exec", "atcoder-problem-fetcher"]
