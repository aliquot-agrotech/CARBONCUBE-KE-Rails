# Use Ruby 3.3.6 official image as base
FROM ruby:3.3.6

# Set working directory
WORKDIR /app

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application files
COPY . .

# Expose the port for Rails
EXPOSE 3001

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]
