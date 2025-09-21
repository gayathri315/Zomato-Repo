# Use Node.js 16 slim as the base image
FROM node:16-slim AS Builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Expose port 3000 (or the port your app is configured to listen on)
EXPOSE 3000

#------second stage--------
FROM node:16-alpine AS final

WORKDIR /app

# Copy only package.json first for better caching
COPY package*.json ./
RUN npm install --production

# Copy backend/server code
COPY . .

# Copy built frontend from builder stage
COPY --from=builder /app/build ./build

# Expose port 3000 (or the port your app is configured to listen on)
EXPOSE 3000

# Start your Node.js server (assuming it serves the React app)
CMD ["npm", "start"]
