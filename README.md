# Project Name

ruby-backend-challenge. It's a Fudo technical challenge

## Prerequisites

- Docker installed on your machine.

## How to Run the Project

1. Clone this repository

   ```bash
   git clone https://github.com/valentinopfarherr/ruby-backend-challenge

2. Navigate to the project directory

3. Build the Docker image
   ```bash
   docker build -t container-name .
(Replace container-name with the desired name for your container)

4. Run the container
   ```bash
   docker run -p 9292:9292 container-name .
(This will map port 9292 from the container to port 9292 on your local machine, allowing you to access your application from a web browser at http://localhost:9292)

# Usage

1. Create a User

   Use the following API endpoint to create a user:
      ```bash
      Endpoint: POST /register
      
      Request Body:
      
      {
        "username": "yourusername",
        "password": "yourpassword"
      }

2. Log In

   Log in with the created user credentials:
   ```bash
   Endpoint: POST /authentication
   
   Request Body:
   {
     "username": "yourusername",
     "password": "yourpassword"
   }

3. Explore Available Requests

   Use the following endpoints to interact with the application:
   
   - To create a product:
      ```bash
      Endpoint: POST /products/create
      
      Request Body:
      
      {
        "name": "Product Name"
      }
   
   - To retrieve all products:
      ```bash
      Endpoint: GET /products

# Postman Collection

https://www.postman.com/valentinopfarherr/workspace/ruby-challenge
