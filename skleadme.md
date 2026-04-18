<a name="top"></a>
[![Personal Cloud Platform](assets/banner.png)](https://tanager-solutions.com)

# Improved Readme
**Status: In Progress**

[![Static Badge](https://img.shields.io/badge/Online-%23F38020?style=for-the-badge&logo=cloudflare&label=live%20site)](https://www.tanager-solutions.com/)
[![Deploy to Azure Static Web App](https://img.shields.io/github/actions/workflow/status/DrQ-14/CloudResumeSDK/deploy.yml?style=for-the-badge)](https://github.com/DrQ-14/CloudResumeSDK/actions/workflows/deploy.yml)
[![Microsoft Azure](https://custom-icon-badges.demolab.com/badge/Microsoft%20Azure-0089D6?style=for-the-badge&logo=msazure&logoColor=white)](https://azure.microsoft.com/en-us)
[![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=fff)](https://developer.hashicorp.com/terraform)
[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4?style=for-the-badge&)](https://dotnet.microsoft.com/en-us/)

## Table of Contents

- [About](#about-what-is-this)
- [Project Evaluation](#project-evaluation)
- [Architecture](#architecture-decisions-and-why-they-were-made)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact-me)

## About (What is this)

- What is it called?

    This repo is called my personal cloud platform.

- Why does it exist?

    This platform exists as an easy way to share the cloud technology, praxis and problems that I am familiar with and capable of solving.

- Where do I find it again?

    The static website can be found here: [tanager-solutions.com](https://www.tanager-solutions.com/) and the associated backend code for the website is found in this repo. An explanation of the full tech stack and why I made my decisions can be found below under [Architecture](#architecture-decisions-and-why-they-were-made), though it should be noted that I focus less on the frontend and more on the backend, the infrastructure and CI/CD pipeline.

## Project Evaluation

- Who is this for?

    This platform is for hiring managers and engineers to quickly assess my capabilities as a cloud engineer and decide whether or not I am suitable for solving the problems that their company is currently working through. Sharing a link to a publicly available website is often faster than uploading, sending, downloading and assessing a CV, thus I have built my platform to be a more scalable solution to the problem of competency assessment by many different teams and organizations that have different needs, hiring processes and talent preferences.

- Who does this help?

    This platform helps any organizations that are in need of cloud talent and determine that I can solve problems that their organization is currently grappling with.

- Where did this come from?

    During the hiring process for many cloud engineer positions my resume was getting lost in translation and getting shoved into piles with other CVs. This platform intends to solve the issue of my skills and capabilites being overlooked due to looking the exact same as every other candidate, or my CV not getting passed around due to difficulty moving it between people.

## Architecture Decisions and Why They Were Made

    The following is my cloud platform's architecture and is set up as a classic seperation of concerns architecture. The stack is seperated into each individual piece and why they exist as they do.


- Testing decisions (and why)

    - Unit test: I created unit tests to validate business logic in isolation by mocking dependencies like the repository. I chose this to ensure fast, reliable tests that focus only on logic, avoiding external systems like databases. This solves the problem of slow and brittle tests caused by real infrastructure dependencies.

    - Integration test components: I separated integration testing into distinct components (fixture, collection, and test types) to clearly isolate responsibilities such as environment setup, resource sharing, and validation. I chose this structure to improve maintainability, reduce duplication, and make failures easier to diagnose by distinguishing between infrastructure issues and application logic issues.

    - Fixture: The fixture manages setup and teardown of the Cosmos DB emulator, database, and container. I created this to centralize expensive and repeated setup logic, ensuring all tests run against a consistent environment. This solves the problem of duplicated setup code and inconsistent test states.
    
    - Collection: The collection groups tests that share the same fixture instance. I used this to reuse the Cosmos DB environment across tests, improving performance and preventing repeated initialization. This solves the problem of slow test execution and unnecessary resource creation.
    
    - Tests:
        - Integration test: These tests validate the full application flow (service → repository → database). I included them to ensure components work together correctly in a real environment. This solves the problem of missing issues that only appear during real data persistence and retrieval.

        - Smoke test: Smoke tests perform basic read/write operations against the database to confirm the environment is functioning correctly. I separated these from integration tests to quickly identify whether failures are caused by infrastructure or application logic. This solves the problem of unclear test failures and speeds up debugging.


    When I previously attempted to build this cloud platform, I used Cosmos DB triggers and bindings. This approach proved less suitable for my needs, as it created tight coupling between components, made debugging more difficult, and in some cases resulted in failures that were hard to trace.

    To address these issues, I redesigned the system using a more explicit, layered architecture with dependency injection and clear separation of concerns. They are listed below.
    

- Function
    - Host configuration: This is where I set up dependency injection and the core wiring of my Azure Function. I used this approach to avoid tight coupling between components and to make the system easier to test and modify without changing core logic.
    - Function: The function receives a service via dependency injection, calls it to increment the counter, and returns the updated value as JSON for the client to use (e.g. a frontend). I chose to keep this layer minimal so it only handles request/response logic, which reduces complexity, improves testability, and makes debugging deployment issues easier because business logic is not embedded in the function.
    
    - Models: I created this domain model to represent the counter in a consistent structure across the system. I used a dedicated model to ensure a single source of truth for the data shape, reduce inconsistencies between layers, and simplify testing by allowing logic to operate on structured objects instead of raw values.
    
    - Repository: This implements the data access layer and handles reading and updating the counter in Cosmos DB. I designed this layer to isolate database logic so that the rest of the system is not dependent on a specific storage technology. This makes the system more flexible and easier to maintain, since the database can be changed without impacting business logic. During development, this also allowed me to use a mock repository for testing before switching to Cosmos DB.
    
    - Interface: The interface defines a contract for repository implementations, requiring only get and update counter operations. I introduced this abstraction to enforce separation between business logic and data access, and to enable dependency inversion so that real, mock, or alternative implementations can be swapped easily for testing or future changes.
    
    - Service: This contains the business logic for incrementing the counter. I created this as a separate service layer to centralise business logic away from the function and repository layers, improving maintainability, enabling reuse across different triggers, and reducing coupling between components.


 - Infrastructure decisions (and why)

    - Bootstrap: This layer initializes Terraform itself by setting up the backend state storage (resource group, storage account, container). I chose to separate this because Terraform cannot manage its own state until storage exists. This ensures infrastructure state is persisted and protected, and prevents state loss or conflicting deployments.

    - Modules: I split infrastructure into modules (Core, Compute, Data, Security) to separate concerns and make each part independently manageable, reusable, and easier to reason about. This reduces complexity and avoids tightly coupled, monolithic configurations that are difficult to maintain.
        - Core: This module provisions foundational resources like the resource group, storage account, and frontend (static web app). I separated this because these are shared dependencies required by other modules. This ensures consistent base infrastructure and avoids duplication of foundational resources.

        - Compute: This module defines the function app, service plan, and application insights. I isolated compute resources so application runtime concerns are separate from storage and data concerns. This decouples runtime configuration from other infrastructure and simplifies scaling and updates.

        - Data: This module provisions Cosmos DB (account, database, container). I separated data resources to isolate persistence concerns and allow independent changes to data configuration (e.g. scaling, consistency levels). This isolates database changes and prevents them from impacting unrelated infrastructure.
        
        - Security: This module manages role assignments and identity (managed identity, RBAC, GitHub OIDC). I isolated security to centralize access control and avoid scattering permissions across modules. This enforces consistent access policies and reduces the risk of misconfigured or overly permissive access.

    - Root: The root module orchestrates all other modules and passes outputs between them (storage -> compute, data -> compute, compute -> security). I designed this as the single entry point to control dependencies and configuration in one place. This ensures coordinated deployments and simplifies management by centralizing how all components are connected.

## Contributing

- Share around
- Give suggestions
- Suggestion box

## License

- License info

## Contact Me

- Contact info
- Connect on LinkedIn

[Back to top](#top)