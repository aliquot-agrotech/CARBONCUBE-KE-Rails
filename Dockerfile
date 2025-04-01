# Use an official Ruby runtime as the base image
FROM ruby:3.3.6

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libvips python3 python3-pip python3-opencv

# Set the working directory in the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Copy Python scripts into the container
COPY scripts/ /app/scripts/

# Ensure Python scripts are executable
RUN chmod +x /app/scripts/*.py  

# Expose the port the app runs on
EXPOSE 3001

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]