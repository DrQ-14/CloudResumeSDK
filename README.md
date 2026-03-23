# Personal Cloud Platform
This project implements the Cloud Resume Challenge using Azure services.
It demonstrates cloud architecture, infrastructure as code, serverless
development, and CI/CD practices.

The resume is hosted as a static website with a visitor counter powered
by a serverless backend. The backend is configured using the cosmosDB SDK
through the Dotnet isolated worker model rather than using extensions through
the in process model and is focused on setting up more robust business logic
for real world applicability.

Live Site: https://tanager-solutions.com

## Architecture

This project implements a cloud-native resume application using a serverless backend, automated infrastructure provisioning, and a fully automated CI/CD pipeline.

### Frontend

The frontend is a static website that serves the resume content to users.

- Hosted as a **static webpage**
- Delivered securely through **Cloudflare**, which provides:
  - DNS management
  - CDN caching
  - Security protections

### Backend

The backend provides a visitor counter API.

- Built using **Azure Functions**
- Exposes a **serverless API endpoint**
- Stores visitor data in **Azure Cosmos DB**

**Request Flow**

1. A visitor loads the webpage.
2. The frontend calls the API endpoint.
3. The Azure Function processes the request.
4. The visitor count is read from and updated in Cosmos DB.
5. The updated count is returned to the frontend.

### Infrastructure

All cloud resources are managed using **Infrastructure as Code**.

- **Terraform** provisions and manages Azure resources
- Infrastructure configuration is version controlled in the repository
- Changes to infrastructure are reproducible and automated

### CI/CD Pipeline

Both the frontend and backend are deployed automatically.

- **GitHub Actions** triggers workflows on code pushes
- Deployment pipelines are defined using **YAML configuration**
- Backend Azure Functions are deployed using a **ZIP package**
- Frontend static files are deployed automatically through the same pipeline

### Testing Strategy

The project includes multiple levels of automated testing.

**Unit Testing**

- Implemented using **xUnit**
- Dependencies mocked using **Moq**

**Integration Testing**

- Uses the **Cosmos DB Emulator** running locally in **Docker**
- Validates interactions between the API and database

**Smoke Testing**

- Ensures core functionality works after deployment
- Confirms that the API and database integration remain operational

## Technologies

### Cloud Platform

- **`Microsoft Azure`** – Primary cloud platform used to host and manage the application infrastructure.
- **`Azure Functions`** – Serverless compute powering the backend API.
- **`Azure Cosmos DB`** – Globally distributed NoSQL database used to store application data.
- **`Azure Storage`** – Stores static assets for the application.
- **`Static Web Hosting`** – Hosts and serves the frontend resume site.

### Infrastructure & DevOps

- **`Terraform`** – Infrastructure as Code used to provision and manage Azure resources.
- **`GitHub Actions`** – CI/CD pipelines used to automate testing and deployment.
- **`YAML Deployment Pipelines`** – Defines automated workflows and deployment steps.
- **`Docker`** – Runs the Cosmos DB Emulator locally for development and testing.
- **`Cloudflare`** – Provides DNS management, CDN delivery, and security protection.

### Testing

- **`xUnit`** – Framework used for automated unit testing of backend services.
- **`Moq`** – Mocking framework used to isolate dependencies in unit tests.
- **Integration Testing** – Ensures multiple components work together correctly.
- **Smoke Testing** – Validates critical functionality after deployments.
- **`Cosmos DB Emulator`** – Local testing environment for Azure Cosmos DB interactions.

## Visitor Counter

A serverless visitor counter tracks page views and displays the total number of visits on the resume webpage.

### Flow

1. A user visits the static resume webpage.
2. The frontend sends a request to the backend API endpoint.
3. An **Azure Function** processes the request.
4. The function reads and updates the visitor count stored in **Azure Cosmos DB**.
5. The updated count is returned to the frontend and displayed on the webpage.

### Implementation Details

- Backend API built using **Azure Functions**
- Visitor data stored in **Azure Cosmos DB**
- Frontend calls the API using JavaScript
- The API returns the updated visitor count in the response

## CI/CD

Deployment is fully automated using **GitHub Actions**.

- Code pushed to the **main branch** triggers the workflow
- **Backend Azure Functions** deployed using a **ZIP package** via **YAML deployment pipelines**
- **Frontend static website** deployed automatically through YAML configuration
- **Infrastructure** provisioned and managed with **Terraform**
- Entire process ensures repeatable, automated deployments for both backend and frontend

## Lessons Learned

- Designing and implementing a **serverless backend** using Azure Functions
- Managing cloud infrastructure using **Terraform Infrastructure as Code**
- Integrating a **static frontend with a serverless API**
- Storing and retrieving application data using **Azure Cosmos DB**
- Implementing **automated CI/CD pipelines** with GitHub Actions and YAML workflows
- Writing **unit tests with xUnit and Moq** to ensure backend reliability
- Running **integration and smoke tests** using the Cosmos DB Emulator in Docker
- Securing and delivering a web application using **Cloudflare DNS and CDN**

## Future Improvements

- **Minify and optimize CSS** to reduce file size and improve page load speed  
- Implement **unique visitor tracking** to only increment the counter for new visitors
- Add **improved comments for clarity** throughout the codebase