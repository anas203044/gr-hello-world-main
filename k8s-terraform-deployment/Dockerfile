# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY ./node-application/* ./

# Install the application dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose a port for the Node.js application to listen on
EXPOSE 3000

# Set the command to run the Node.js application
CMD ["node", "index.js"]