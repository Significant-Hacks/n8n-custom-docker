FROM node:18-alpine

# Install necessary packages using apk
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev \
    pixman-dev \
    git

# Set working directory
WORKDIR /home/node/app

# Copy package files
COPY package*.json ./

# Install Node dependencies
RUN npm ci --only=production

# Copy application files
COPY . .

# Expose port
EXPOSE 5678

# Start the application
CMD ["node", "dist/index.js"]
